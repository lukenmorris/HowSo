//
//  AuthManager.swift
//  howso
//
//  Created by Luke Morris on 7/13/22.
//

import Firebase
import Foundation

class AuthManager {
    static let shared = AuthManager()
    
    private let auth = Auth.auth()
    
    private var verificationID: String?
    
    public func signUpUser(phone_number: String, completion: @escaping (Bool) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phone_number, uiDelegate: nil) { verificationID, error in
            if let error = error {
                self.errorMsg = error.localizedDescription
                return
            }
            self?.verificationID = verificationID
            completion(true)
        }
    }
    
    public func verifyCode(smsToken: String, completion: @escaping (Bool) -> Void) {
        guard let verificationID = verificationID else {
            completion(false)
            return
        }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: smsToken)
        
        auth.signIn(with: credential) {
            result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
}
