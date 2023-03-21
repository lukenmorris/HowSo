//
//  PostReport.swift
//  howso
//
//  Created by Luke Morris on 3/20/23.
//

import Foundation
import FirebaseFirestoreSwift

struct PostReport: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var post: Post
    var createdOn: Date
    var createdBy: String
    var reason: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case post
        case createdOn
        case createdBy
        case reason
    }
}

