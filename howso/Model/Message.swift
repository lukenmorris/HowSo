//
//  Message.swift
//  howso
//
//  Created by Luke Morris on 2/16/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Message: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var postedOn: Date
    var postedBy: String
    var conversationID: String
    var text: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case postedOn
        case postedBy
        case conversationID
        case text
    }
}
