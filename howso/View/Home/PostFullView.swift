//
//  CommentView.swift
//  howso
//
//  Created by Luke Morris on 7/5/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct PostFullView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var commentModel = commentService()
    @ObservedObject private var authModel = authService()
    var post: Post
    @State private var commentText = ""
    @Binding var isCommentViewActive: Bool
    @State private var selectedTab = Tabs.FirstTab
    
    var body: some View {
        ZStack {
            if commentModel.isLoading {
                FilledLoadingView()
            } else {
                VStack {
                    VStack {
                        HStack {
                            Text("Comments")
                                .frame(alignment: .topLeading)
                                .font(.headline)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        ScrollView {
                            VStack {
                                ForEach(commentModel.comments, id: \.id) { Comment in
                                    CommentView(comment: Comment)
                                }
                            }
                        }
                        Spacer()
                    }
                    .onTapGesture {
                        self.hideKeyboard()
                    }
                    HStack {
                        TextField("Add a comment...", text: $commentText)
                        if commentModel.isCommentLoading {
                            SmallLoadingView()
                        } else {
                            Button(action: {
                                Task {
                                    await commentModel.postComment(comment: Comment(postedOn: Date(), postID: post.id!, postedBy: Auth.auth().currentUser!.uid, commentText: commentText))
                                }
                            }) {
                                Image(systemName: "paperplane.circle.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color("primaryYellow"))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.gray.opacity(0.5))
                    )
                }
                .padding()
            }
        }
        .onAppear {
            Task {
                await commentModel.fetchCommentData(postID: post.id ?? "")
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

enum Tabs {
    case FirstTab
    case SecondTab
    case ThirdTab
}

/*
 struct CommentView_Previews: PreviewProvider {
 static var previews: some View {
 CommentView(comment: Comment)
 }
 }
 */

/*Text(post.statement)
 .font(.title2)
 .padding()
 .overlay(
 Capsule(style: .continuous).stroke(Color(.systemYellow), lineWidth: 5))
 Spacer()
 HStack {
 ForEach(commentModel.currentPostComments, id: \.self) { comment in
 if (comment.commentAgree == true) {
 Text(comment.commentText)
 .font(.title2)
 .padding()
 .frame(alignment: .leading)
 .background(Color(.green))
 } else {
 Text(comment.commentText)
 .font(.title2)
 .padding()
 .frame(alignment: .trailing)
 .background(Color(.red))
 }
 }
 }
 Spacer()
 Button(action: {
 presentationMode.wrappedValue.dismiss()
 isCommentViewActive = false
 }) {
 Image(systemName: "arrow.down")
 .padding()
 }
 .onAppear() {
 self.commentModel.fetchCommentData(postID: post.id ?? "")
 }
 */
