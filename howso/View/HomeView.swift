//
//  HomeView.swift
//  howso
//
//  Created by Luke Morris on 6/25/22.
//

import SwiftUI

struct HomeView: View {
    
    @State private var NavigationBarHidden = false
    @EnvironmentObject var authViewModel : authService
    
    var body: some View {
        TabView {
            PostGridView(NavigationBarHidden: $NavigationBarHidden)
                .tabItem {
                    Text("Home")
                    Image(systemName: "house.fill")
                }
                .environmentObject(authViewModel)
            PersonalProfileView(NavigationBarHidden: $NavigationBarHidden)
                .environmentObject(authService())
                .navigationBarTitle("")
                .tabItem {
                    Text("Profile")
                    Image(systemName: "person.crop.circle.fill")
                }
            NotificationView()
                .navigationBarTitle("")
                .tabItem {
                    Text("Notifications")
                    Image(systemName: "bell.fill")
                }
                .environmentObject(authViewModel)
        }
        .accentColor(.orange)
    }
}

/*struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
    }
}*/
