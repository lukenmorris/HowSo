//
//  LoginViewModel.swift
//  howso
//
//  Created by Luke Morris on 7/16/22.
//

import Foundation
import SwiftUI
import Combine
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

enum AuthState {
    case loading, logged, unlogged, username
}

class authService: ObservableObject {
    @Published var authState: AuthState = .loading
    @ObservedObject var keyService = verifyKeyService()
    @ObservedObject var postModel = postService()
    @ObservedObject var commentModel = commentService()
    
    @Published var firstFetchingAuth = true
    @Published var phone_number : String = ""
    @Published var username : String = ""
    @Published var userExists = false
    
    @Published var timerExpired = false
    @Published var timeStr = ""
    @Published var timeRemaining = 60
    var codeCooldownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Published var code = ""
    @Published var phoneAuth = ""
    
    // getting country Phone Code....
    
    // DataModel For Error View...
    @Published var errorMsg = ""
    @Published var error = false
    @Published var user: User?
    
    // storing CODE for verification...
    @Published var verificationID = ""
    @Published var registerUser = false
    @Published var showVerification = false
    
    // Loading View....
    @Published var loading = false
    
    init() {
        listenToAuthState()
    }
    
    func listenToAuthState() {  // fix this function calling itself often by taking out the loading case of authState and make it a seperate variable
        Auth.auth().addStateDidChangeListener { [weak self] _, _ in
            guard let self = self else {
                return
            }
            if let currentUser = Auth.auth().currentUser {
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(currentUser.uid)
                userRef.getDocument { document, error in
                    if let document = document, document.exists {
                        do {
                            self.user = try document.data(as: User.self)
                            if let username = self.user?.username, !username.isEmpty {
                                self.username = self.user?.username ?? ""
                                self.authState = .logged
                            } else {
                                self.authState = .username
                                print("The username field does not exist or is empty")
                            }
                            print("\(self.user?.id ?? "") logged in")
                        } catch {
                            print("Error decoding user data: \(error)")
                        }
                    } else {
                        print("Session is present, but the user does not exist in /users")
                    }
                }
            } else {
                print("No session present. User is not signed in")
                self.authState = .unlogged
            }
        }
    }
    
    func signOut() {
        if Auth.auth().currentUser != nil {
            do {
                self.phone_number = ""
                self.username = ""
                self.code = ""
                try Auth.auth().signOut()
                self.authState = .unlogged
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func getCountryCode()->String{
        let regionCode = Locale.current.regionCode ?? ""
        return countries[regionCode] ?? ""
    }
    
    // sending Code To User....
    func sendCode() {
        // enabling testing code...
        // disable when you need to test with real device...
        
        Auth.auth().settings?.isAppVerificationDisabledForTesting = false
        
        let number = "+\(getCountryCode())\(phone_number)"
        PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (phoneAuth, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.loading = false
            UserDefaults.standard.set(phoneAuth, forKey: "authVerificationID")
            self.phoneAuth = phoneAuth ?? ""
            print("Phone has been registered succesfully")
            withAnimation {
                self.showVerification = true
            }
        }
    }
    
    func verifyCode() {
        let db = Firestore.firestore()
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.phoneAuth, verificationCode: self.code)
        loading = true
        Auth.auth().signIn(with: credential) { result, error in
            self.loading = false
            if let error = error {
                print(error.localizedDescription)
            }
            // else user logged in Successfully ....
            self.code = ""
            Task {
                if await self.checkIfUserExists() == false {
                    do {
                        try await db.collection("users").document("\(result?.user.uid ?? "")").setData([
                            "id": result?.user.uid ?? "",
                            "phone_number": self.phone_number,
                            "username": self.username
                        ])
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            //self.user = Auth.auth().currentUser
            withAnimation {
                self.listenToAuthState()
            }
        }
        /*let user = Auth.auth().currentUser
         if let user = user {
         let uid = user.uid
         let phone_number = user.phone_number
         let username = user.username
         let first_login = user.first_login
         }*/
    }
    
    func requestCode() {
        sendCode()
        withAnimation{
            self.errorMsg = "Code Sent Successfully !!!"
            self.error.toggle()
        }
    }
    
    func limitText(_ upper: Int) {
        if code.count > upper {
            code = String(code.prefix(upper))
        }
    }
    
    func getCode(index: Int) -> String {
        if self.code.count > index {
            let start = self.code.startIndex
            let current = self.code.index(start, offsetBy: index)
            return String(self.code[current])
        }
        return ""
    }
    
    func stopTimer() {
        self.codeCooldownTimer.upstream.connect().cancel()
    }
    
    func startTimer() {
        timeRemaining = 60
        timerExpired = false
        self.codeCooldownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    func countDownString() {
        guard (timeRemaining > 0) else {
            self.codeCooldownTimer.upstream.connect().cancel()
            timerExpired = true
            timeStr = String(format: "%02d:%02d", 00,  00)
            return
        }
        
        timeRemaining -= 1
        timeStr = String(format: "%02d:%02d", 00, timeRemaining)
    }
    
    @MainActor
    func checkIfUserExists() async -> Bool {
        let user = Auth.auth().currentUser
        let agreeDB = Firestore.firestore().collection("users").document(user?.uid ?? "")
        do {
            let document = try await agreeDB.getDocument()
            if document.exists {
                return true
            } else {
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    @MainActor
    func doesUsernameExist(username: String) async -> Bool {
        let usernameDB = Firestore.firestore().collection("usernames").document(username)
        do {
            let document = try await usernameDB.getDocument()
            if document.exists {
                return true
            } else {
                return false
            }
        } catch {
            print(error.localizedDescription)
            return true
        }
    }
    
    func setUsername(username: String) {
        let usernameDB = Firestore.firestore().collection("usernames").document(username)
        let userDB = Firestore.firestore().collection("users").document(user?.id ?? "")
        usernameDB.setData([
            "account_uid": user?.id ?? "" as Any
        ])  { err in
            if let err = err {
                print("Error reserving username: \(err)")
            } else {
                print("Username successfully reserved")
            }
        }
        userDB.updateData([
            "username": username
        ])  { err in
            if let err = err {
                print("Error setting username: \(err)")
            } else {
                print("Username successfully set")
            }
        }
    }
}
