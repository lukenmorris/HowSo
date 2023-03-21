//
//  Post.swift
//  howso
//
//  Created by Luke Morris on 7/5/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Post: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var createdBy: String
    var createdOn: Date
    var statement: String
    //var profile_pic: String
    //var anonymous: Bool = false
    var popularity: Int = 0
    var viewCount: Int = 0
    var agreeCount: Int = 0
    var disagreeCount: Int = 0
    var reactionCount: Int = 0
    var commentCount: Int = 0
    var agreeCommentCount: Int = 0
    var disagreeCommentCount: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdBy
        case createdOn
        case statement
        case popularity
        case viewCount
        case commentCount
        case agreeCommentCount
        case disagreeCommentCount
        //case profile_pic
        //case anonymous
        case agreeCount
        case disagreeCount
        case reactionCount
    }
}
