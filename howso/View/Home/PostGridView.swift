//
//  PostGridView.swift
//  howso
//
//  Created by Luke Morris on 7/2/22.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseFirestoreSwift

struct PostGridView: View {
    @ObservedObject private var postModel = postService()
    @ObservedObject private var commentModel = commentService()
    @Binding var NavigationBarHidden : Bool
    @State private var isSettingsActive = false
    @State private var isNewPostActive = false
    @State private var showPosts = false
    @State private var showingRecent = true
    var body: some View {
        ZStack {
            if postModel.isLoading {
                FilledLoadingView()
            } else {
                    ScrollView(showsIndicators: false) {
                        NavigationLink(destination: SettingsView(), isActive: $isSettingsActive) { //connects with toolbar button action
                        }
                        VStack(spacing: 30) {
                            ForEach(postModel.posts, id: \.id) { Post in
                                if showPosts {
                                    PostView(post: Post)
                                        .transition(.move(edge: .bottom))
                                }
                            }
                        }
                        .padding()
                    }
                    .navigationBarHidden(NavigationBarHidden)
                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarTitleDisplayMode(.inline)
                    .sheet(isPresented: $isNewPostActive) {
                        NewPostView()
                    }
                    .refreshable {
                        showPosts = false
                        if showingRecent {
                            await postModel.fetchRecentPostData()
                        } else {
                            await postModel.fetchPopularPostData()
                        }
                        withAnimation(.interpolatingSpring(stiffness: 300, damping: 15)) {
                            showPosts = true
                        }
                    }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            isNewPostActive = true
                        }) {
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 70, weight: .light))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(LinearGradient(
                                    colors: [Color("primaryYellow"), .white], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.75), LinearGradient(
                                        colors: [Color("primaryYellow"), .orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .shadow(radius: 8, x: 8, y: 8)
                        }
                    }
                    .padding()
                }
                .frame(maxHeight: .infinity)
                .padding()
            }
            /*.overlay(
             Button(action: {
             isNewPostActive.toggle()
             }, label: {
             Image(systemName: "plus.circle.fill")
             .resizable()
             .frame(width: 70, height: 70, alignment: .bottomTrailing)
             .padding(.top, 600)
             .padding(.leading, 285)
             .foregroundColor(.primaryYellow)
             }))*/
        }
        .onChange(of: showingRecent) { newValue in
            if newValue == false {
                Task {
                    await postModel.fetchPopularPostData()
                }
            } else {
                Task {
                    await postModel.fetchRecentPostData()
                }
            }
        }
        .background(LinearGradient(colors: [Color("primaryYellow"), .orange], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.75))
        .onAppear {
            self.NavigationBarHidden = false
        }
        .task {
            if postModel.posts.isEmpty {
                await postModel.fetchRecentPostData()
                withAnimation(.interpolatingSpring(stiffness: 300, damping: 15)) {
                    showPosts = true
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    isSettingsActive = true
                }, label: {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(Color(.systemGray))
                })
            }
            ToolbarItem(placement: .principal) {
                Image("logoWhite")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action:{
                    showingRecent.toggle()
                }, label: {
                    Image(systemName: self.showingRecent == true ? "clock.arrow.circlepath" : "flame.fill")
                        .foregroundColor(.orange)
                })
            }
        }
    }
}

/*struct PostGridView_Previews: PreviewProvider {
 static var previews: some View {
 NavigationView {
 TabView {
 PostGridView().environmentObject(authService())
 }
 }
 }
 }*/

