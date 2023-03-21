//
//  MessageService.swift
//  howso
//
//  Created by Luke Morris on 2/16/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

class reportService: ObservableObject {
    @Published var conversations = [Conversation]()
    @Published var isReportLoading: Bool = false
    private var postReportsDB = Firestore.firestore().collection("postReports")
    
    func reportPost(postReport: PostReport) async {
        isReportLoading = true
        let db = Firestore.firestore().collection("posts")
        do {
            let _ = try await postReportsDB.addDocument(from: postReport)
            print("Comment posted successfully")
        } catch {
            print("Error posting comment: \(error)")
        }
        isReportLoading = false
    }
}
