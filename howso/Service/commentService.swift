//
//  CommentViewModel.swift
//  howso
//
//  Created by Luke Morris on 10/1/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

class commentService: ObservableObject{
    @Published var isLoading: Bool = true
    @Published var isCommentLoading: Bool = false
    @Published var comments = [Comment]()
    private var commentsDB = Firestore.firestore().collection("posts")
    
    @MainActor
    func fetchCommentData(postID: String) async {
        do {
            comments.removeAll()
            
            isLoading = true
            
            let snapshot = try await commentsDB.document(postID).collection("comments").getDocuments()
            let documents = snapshot.documents
            let data = documents.compactMap({ try? $0.data(as: Comment.self) })
            comments.append(contentsOf: data)
            isLoading = false
            
        } catch {
            print(error.localizedDescription)
            return
        }
    }

    func postComment(comment: Comment) async {
        isCommentLoading = true
        let db = Firestore.firestore().collection("posts")
        do {
            let _ = try await db.document(comment.postID).collection("comments").addDocument(from: comment)
            print("Comment posted successfully")
            try await db.document(comment.postID).updateData([
                "commentCount": FieldValue.increment(Int64(1)),
                "agreeCommentCount": FieldValue.increment(Int64(1)),
                "popularity": FieldValue.increment(Int64(4))
            ])
        } catch {
            print("Error posting comment: \(error)")
        }
        isCommentLoading = false
    }
    
    @MainActor
    func getCommentAuthor(userID: String) async throws -> User? {
        do {
            let querySnapshot = try await Firestore.firestore().collection("users").whereField(FieldPath.documentID(), isEqualTo: userID).getDocuments()
            guard let document = querySnapshot.documents.first else { return nil }
            return try document.data(as: User.self)
        } catch {
            print("Error getting comment author: \(error)")
            throw error
        }
    }
}


/*commentsDB.document("\(postID)").collection("comments")
    .order(by: "id")
    .limit(to: 3)
    .getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting comments for Post ID \(postID): \(err)")
        } else {
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data())")
            }
        }
    }*/
