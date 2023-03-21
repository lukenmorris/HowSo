//
//  Conversation.swift
//  howso
//
//  Created by Luke Morris on 2/16/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Conversation: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var startedOn: Date
    var startedBy: String
    var members: [User]?
    var messages: [Message]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case startedOn
        case startedBy
        case members
        case messages
    }
}
