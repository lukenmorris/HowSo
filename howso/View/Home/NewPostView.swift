//
//  NewPostView.swift
//  howso
//
//  Created by Luke Morris on 7/5/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct NewPostView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var postModel = postService()
    @ObservedObject private var authModel = authService()
    @State private var statement = ""
    @State private var isAnonymous = false
    @FocusState private var keyboardFocused: Bool
    @State private var characters: Double = 0
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("New Post")
                        .font(.headline)
                        .frame(alignment: .topLeading)
                        .padding(.leading)
                    Spacer()
                    HStack {
                        Toggle(isOn: $isAnonymous) {
                            Image(systemName: isAnonymous ? "person.crop.circle.badge.questionmark" : "person.circle.fill")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .toggleStyle(.switch)
                    }
                    .frame(alignment: .topTrailing)
                    .padding(.trailing)
                }
                VStack {
                    TextEditor(text: $statement)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .focused($keyboardFocused)
                        .onChange(of: statement) { _ in
                            characters = Double(statement.count)
                            
                            if statement.count > 150 {
                                statement = String(statement.dropLast(statement.count - 150))
                            }
                        }
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                keyboardFocused = true
                            }
                        }
                    Text("\(statement.count)/150")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding()
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color("primaryYellow").opacity(0.5))
                )
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            Spacer()
            HStack {
                    Button(action: {
                        Task {
                            try await postModel.newPost(post: Post(createdBy: Auth.auth().currentUser!.uid, createdOn: Date(), statement: statement))
                            dismiss()
                        }
                }, label: {
                    Text("Post")
                        .fontWeight(.bold)
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding()
                })
                .frame(maxWidth: .infinity)
                .background(LinearGradient(
                    colors: [Color("primaryYellow"), .orange], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.75))
                .cornerRadius(25)
                .overlay(RoundedRectangle(cornerRadius: 25, style: .continuous).stroke(Color.gray, lineWidth: 2).opacity(0.3))
                .clipShape(Capsule())
                .padding()
            }
            Spacer()
        }
        .padding()
        .background(LinearGradient(
            colors: [Color("primaryYellow"), .orange], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.5).ignoresSafeArea(.all))
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView()
    }
}
