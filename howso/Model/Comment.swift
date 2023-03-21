//
//  Comment.swift
//  howso
//
//  Created by Luke Morris on 10/1/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Comment: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var postedOn: Date
    var postID: String
    var postedBy: String
    var commentText: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case postedOn
        case postID
        case postedBy
        case commentText
    }
}
