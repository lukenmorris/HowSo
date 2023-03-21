//
//  SettingsView.swift
//  howso
//
//  Created by Luke Morris on 11/23/22.
//

import SwiftUI

extension Color {
    static let primaryYellow = Color(red: 255/255, green: 207/255, blue: 71/255)
}

/*struct SettingsView: View {
    @EnvironmentObject private var loginData : authService
    var body: some View {
            Form {
                Section {
                    Button(action: {}) {
                        Text("Terms of Use")
                    }
                    Button(action: {}) {
                        Text("Privacy Policy")
                    }
                    Button(action: {
                            loginData.signOut()
                            }) {
                            Text("Sign Out")
                        }
                }
                }
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationTitle(Text("Settings"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.black)
                .font(
                    .title2
                        .weight(.bold)
                )
        }
    }*/

struct SettingsView: View {
    @EnvironmentObject private var loginData : authService
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Link("Terms of Service", destination: URL(string: "https://www.howsoapp.com/TOS")!)
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                .padding()
                Divider()
                HStack {
                    Link("Privacy Policy", destination: URL(string: "https://www.howsoapp.com/privacy-policy")!)
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                .padding()
                Divider()
                HStack {
                    Text("Sign Out")
                        .onTapGesture {
                            loginData.signOut()
                        }
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                .padding()
            }
            .padding(.top)
            .padding(.bottom)
            .navigationTitle(Text("Settings"))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .foregroundColor(.black)
            .font(
                .title3
                    .weight(.bold)
            )
            Text("Version 0.1")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
