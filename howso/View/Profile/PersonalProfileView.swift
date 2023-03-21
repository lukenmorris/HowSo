//
//  ProfileView.swift
//  howso
//
//  Created by Luke Morris on 1/11/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct PersonalProfileView: View {
    @StateObject private var postModel = postService()
    @EnvironmentObject var authModel : authService
    @Binding var NavigationBarHidden : Bool
    
    var body: some View {
        ZStack {
            if postModel.isLoading {
                FilledLoadingView()
            } else {
                VStack {
                    VStack {
                        VStack {
                            Image("default-pic")
                                .resizable()
                                .frame(width: 85, height: 85)
                                .frame(maxWidth: .infinity)
                            Text(authModel.username)
                                .font(.title).bold()
                        }
                        HStack {
                            VStack {
                                Text("\(authModel.user?.postCount ?? 0)")
                                Text("Posts")
                            }
                            .frame(maxWidth: .infinity)
                            VStack {
                                Text("\(authModel.user?.followerCount ?? 0)")
                                Text("Followers")
                            }
                            .frame(maxWidth: .infinity)
                            VStack {
                                Text("\(authModel.user?.followingCount ?? 0)")
                                Text("Following")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding()
                    }
                    VStack(spacing: 30) {
                        ScrollView {
                            ForEach(postModel.personalProfilePosts, id: \.id) { Post in
                                ProfilePostView(post: Post)
                                    .transition(.move(edge: .bottom))
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .background(LinearGradient(colors: [Color("primaryYellow"), .orange], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.75))
        .onAppear {
            self.NavigationBarHidden = true
        }
        .task {
            if postModel.isPersonalProfileFirstFetching {
                await postModel.fetchPersonalProfilePosts(userID: authModel.user?.id ?? "")
            }
        }
        .navigationBarHidden(NavigationBarHidden)
    }
}

/*struct ProfileView_Previews: PreviewProvider {
 static var previews: some View {
 ProfileView()
 }
 }*/
