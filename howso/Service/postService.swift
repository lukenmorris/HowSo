//
//  PostViewModel.swift
//  howso
//
//  Created by Luke Morris on 8/31/22.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseStorage

class postService: ObservableObject {
    @Published var posts = [Post]()
    @Published var personalProfilePosts = [Post]()
    @Published private (set) var isPersonalProfileFirstFetching: Bool = true
    var userdb = Firestore.firestore().collection("user")
    var postdb = Firestore.firestore().collection("posts")
    private var recentPostsLastDocument: QueryDocumentSnapshot?
    private var popularPostsLastDocument: QueryDocumentSnapshot?
    private var personalPostsLastDocument: QueryDocumentSnapshot?
    @Published var disagreeExists = false
    @Published var isLoading: Bool = true
    
    @MainActor
    func fetchPopularPostData() async {
        posts.removeAll()
        isLoading = true
        
        do {
            let querySnapshot = try await postdb.order(by: "popularity", descending: true).getDocuments()
            let newPosts = try querySnapshot.documents.compactMap { document -> Post? in
                return try document.data(as: Post.self)
            }
            self.posts.append(contentsOf: newPosts)
            
            // Set the posts property to the array of posts with user data
        } catch {
            print("Error fetching posts: \(error)")
        }
        
        isLoading = false
    }

    
    @MainActor
    func fetchRecentPostData() async {
        posts.removeAll()
        isLoading = true
        
        let recentQuery = postdb
            .order(by: "createdOn", descending: true)
            .limit(to: 5)
        
        do {
            let querySnapshot = try await recentQuery.getDocuments()
            let newPosts = try querySnapshot.documents.compactMap { document -> Post? in
                return try document.data(as: Post.self)
            }
            self.posts.append(contentsOf: newPosts)
            
            // Set the posts property to the array of posts with user data
        } catch {
            print("Error fetching posts: \(error)")
        }
        isLoading = false
    }
    
    /*@MainActor
    func fetchMoreRecentPostData() async {
        posts.removeAll()
        isLoading = true
        
        var recentQuery = postdb
            .order(by: "createdOn", descending: true)
            .limit(to: 5)
        
        if let recentPostsLastDocument = recentPostsLastDocument {
            recentQuery = recentQuery.start(afterDocument: recentPostsLastDocument)
        }
        
        do {
            let querySnapshot = try await recentQuery.getDocuments()
            recentPostsLastDocument = querySnapshot.documents.last
            let newPosts = try querySnapshot.documents.compactMap { document -> Post? in
                return try document.data(as: Post.self)
            }
            self.posts.append(contentsOf: newPosts)
            
            // Set the posts property to the array of posts with user data
        } catch {
            print("Error fetching posts: \(error)")
        }
        isLoading = false
    }*/

    @MainActor
    func fetchPersonalProfilePosts(userID: String) async {
        posts.removeAll()
        isLoading = true
        
        do {
            let querySnapshot = try await Firestore.firestore().collection("posts")
                .whereField("createdBy", isEqualTo: userID)
                .getDocuments()
            let newPosts = try querySnapshot.documents.compactMap { document -> Post? in
                return try document.data(as: Post.self)
            }
            self.posts.append(contentsOf: newPosts)
        } catch {
            print("Error fetching posts: \(error)")
        }
        
        isLoading = false
        isPersonalProfileFirstFetching = false
    }

    func newPost(post: Post) async throws {
        let db = Firestore.firestore().collection("posts")
        let newPost = post
        do {
            let _ = try await db.addDocument(from: newPost)
        } catch {
            throw error
        }
    }
    
    @MainActor
    func agreePost(postID: String) async {
        let db = Firestore.firestore().collection("posts").document(postID)
        let user = Auth.auth().currentUser
        do {
            try await db.updateData([
                "agreeCount": FieldValue.increment(Int64(1)),
                "reactionCount": FieldValue.increment(Int64(1)),
                "popularity": FieldValue.increment(Int64(5))
            ])
            try await db.collection("AgreeUsers").document("\(user?.uid ?? "")").setData([
                "uid": user?.uid as Any
            ])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    func disagreePost(postID: String) async {
        let db = Firestore.firestore().collection("posts").document(postID)
        let user = Auth.auth().currentUser
        do {
            try await db.updateData([
                "disagreeCount": FieldValue.increment(Int64(1)),
                "reactionCount": FieldValue.increment(Int64(1)),
                "popularity": FieldValue.increment(Int64(5))
            ])
            try await db.collection("DisagreeUsers").document("\(user?.uid ?? "")").setData([
                "uid": user?.uid as Any
            ])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    func checkIfAgreeExists(postID: String) async -> Bool {
        let user = Auth.auth().currentUser
        let agreeDB = Firestore.firestore().collection("posts").document(postID).collection("AgreeUsers").document(user?.uid ?? "")
        do {
            let document = try await agreeDB.getDocument()
            if document.exists {
                return true
            } else {
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    @MainActor
    func checkIfDisagreeExists(postID: String) async -> Bool {
        let user = Auth.auth().currentUser
        let agreeDB = Firestore.firestore().collection("posts").document(postID).collection("DisagreeUsers").document(user?.uid ?? "")
        do {
            let document = try await agreeDB.getDocument()
            if document.exists {
                return true
            } else {
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    @MainActor
    func getPostAuthor(userID: String) async throws -> User? {
        do {
            let querySnapshot = try await Firestore.firestore().collection("users").whereField(FieldPath.documentID(), isEqualTo: userID).getDocuments()
            guard let document = querySnapshot.documents.first else { return nil }
            return try document.data(as: User.self)
        } catch {
            print("Error getting post author: \(error)")
            throw error
        }
    }
    
    func addView(postID: String) async {
        let db = Firestore.firestore().collection("posts").document(postID)
        do {
            try await db.updateData([
                "viewCount": FieldValue.increment(Int64(1)),
                "popularity": FieldValue.increment(Int64(1))
            ])
        } catch {
            print(error.localizedDescription)
        }
    }
}
