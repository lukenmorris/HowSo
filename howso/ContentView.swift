//
//  ContentView.swift
//  howso
//
//  Created by Luke Morris on 5/15/22.
//


import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var elapsedTime = 0.0
    @StateObject private var authModel = authService()
    var body: some View {
            NavigationView {
                switch(authModel.authState) {
                case .loading:
                    LoadingView().preferredColorScheme(.light)
                        .navigationBarTitle("")
                case .username:
                    UsernameView().preferredColorScheme(.light)
                        .navigationTitle("")
                        .environmentObject(authModel)
                case .logged:
                    HomeView().preferredColorScheme(.light)
                        .navigationBarTitle("")
                        .environmentObject(authModel)
                case .unlogged:
                    GetStartedView().preferredColorScheme(.light)
                        .navigationBarTitle("")
                        .environmentObject(authModel)
                }
            }
            .onAppear(perform: {
                authModel.listenToAuthState()
            })
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(authService())
    }
}
