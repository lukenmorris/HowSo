//
//  LoginView.swift
//  howso
//
//  Created by Luke Morris on 6/29/22.
//

import SwiftUI
import Firebase

/*extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}*/

struct LoginView: View {
    @EnvironmentObject var authViewModel : authService
    @Environment(\.presentationMode) var presentationMode
    @State private var isPerformingTask = false
    @FocusState private var keyboardFocused: Bool
    
    var body: some View {
        VStack {
            Text("Enter your phone number")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top)
                .padding(.bottom, 5)
            Text("We'll send you a verification code.")
                .font(.callout)
                .fontWeight(.light)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            Spacer()
                HStack{
                    HStack(spacing: 0) {
                        Text("🇺🇸")
                            .font(.largeTitle)
                        Text("+ 1")
                            .font(.title)
                    }
                    TextField("Phone Number",  text: $authViewModel.phone_number)
                        .padding()
                        .font(.title)
                        .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .center)
                        .keyboardType(.numberPad)
                        .focused($keyboardFocused)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                keyboardFocused = true
                            }
                        }
                }
                .frame(alignment: .leading)
                .padding()
            Spacer()
            if authViewModel.loading {
                    ProgressView()
                        .padding()
                } else {
                    NavigationLink(destination: VerificationView(loginData: authViewModel), isActive: $authViewModel.showVerification) {
                        Text("").hidden()
                    }
                    Button(action: {
                        authViewModel.loading = true
                            authViewModel.sendCode()
                    }){
                        Text("SIGN IN")
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .foregroundColor(.black)
                            .opacity(isPerformingTask ? 0 : 1)
                    }
                    .disabled(authViewModel.loading)
                    .disabled(authViewModel.phone_number == "" ? true: false)
                    .frame(width: UIScreen.main.bounds.width / 1.25, height: 25, alignment: .center)
                    .padding()
                    .background(Color(.systemYellow))
                    .cornerRadius(35)
                }
                        Text("Text and data rates may apply.")
                            .font(.caption)
                            .fontWeight(.light)
                            .frame(width: UIScreen.main.bounds.width / 1.25, alignment: .center)
                            .multilineTextAlignment(.center)
                            .padding()
                    if authViewModel.error {
                        AlertView(msg: authViewModel.errorMsg, show: $authViewModel.error)
                    }
                }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
            }
        }

/*struct LoginView_Previews: PreviewProvider {
    @EnvironmentObject private var loginData : authService
    var isLoginViewActive = false
    static var previews: some View {
        Group {
            LoginView().environmentObject(authService())
                .previewDevice("iPhone 13 Pro Max")
        }
    }
}*/
