//
//  UsernameView.swift
//  howso
//
//  Created by Luke Morris on 12/29/22.
//

import SwiftUI

struct UsernameView: View {
    @EnvironmentObject var authViewModel : authService
    @Environment(\.presentationMode) var presentationMode
    @State private var isPerformingTask = false
    @State private var isProfilePicViewActive = false
    @State private var UsernameEmpty = true
    @State private var username = ""
    @State private var usernameExists = true
    @FocusState private var keyboardFocused: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Text("What should we call you?")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .top)
                .padding(.top)
                .padding(.bottom, 5)
            Text("Your username will be public.")
                .font(.callout)
                .fontWeight(.light)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            Spacer()
            HStack {
                if UsernameEmpty || usernameExists {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(.red)
                } else {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
                TextField("Username",  text: $username)
                    .font(.title)
                    .keyboardType(.alphabet)
                    .autocorrectionDisabled(true)
                    .multilineTextAlignment(.center)
                    .focused($keyboardFocused)
                    .onChange(of: username, perform: { newValue in
                        Task {
                            username = newValue.replacingOccurrences(of: " ", with: "")
                            if username == "" {
                                self.UsernameEmpty = true
                            } else {
                                self.UsernameEmpty = false
                                usernameExists = await authViewModel.doesUsernameExist(username: username)
                            }
                        }
                    })
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            keyboardFocused = true
                        }
                    }
            }
            .padding()
            Spacer()
            if authViewModel.loading {
                    ProgressView()
                        .padding()
                } else {
                    NavigationLink(destination: ProfilePicView(), isActive: $isProfilePicViewActive) {
                        Text("").hidden()
                    }
                    Button(action: {
                            authViewModel.loading = true
                            if usernameExists {
                                authViewModel.errorMsg = "Error: Username already exists."
                                authViewModel.error.toggle()
                            } else {
                                authViewModel.setUsername(username: username)
                                self.isProfilePicViewActive = true
                                }
                        authViewModel.loading = false
                    }){
                        Text("CONTINUE")
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .foregroundColor(.black)
                            .opacity(isPerformingTask ? 0 : 1)
                    }
                    .contentShape(RoundedRectangle(cornerRadius: 35))
                    .disabled(isPerformingTask)
                    .disabled(usernameExists)
                    .disabled(UsernameEmpty)
                    .opacity(usernameExists ? 0.5 : 1)
                    .opacity(UsernameEmpty ? 0.5 : 1)
                    .frame(maxWidth: .infinity, maxHeight: 25, alignment: .center)
                    .padding()
                    .background(Color(.systemYellow)                    .opacity(usernameExists ? 0.5 : 1)
                        .opacity(UsernameEmpty ? 0.5 : 1))
                    .cornerRadius(35)
                }
            Button(action: {
                self.keyboardFocused = false
                authViewModel.signOut()
            }) {
                Text("Sign out")
            }
            if authViewModel.error {
                AlertView(msg: authViewModel.errorMsg, show: $authViewModel.error)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
            }
        }

struct UsernameView_Previews: PreviewProvider {
    static var previews: some View {
        UsernameView().environmentObject(authService())
    }
}
