//
//  User.swift
//  howso
//
//  Created by Luke Morris on 7/6/22.
//

import SwiftUI
import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var phone_number: String
    //var dateCreated = Date()
    var username: String
    var postCount: Int = 0
    var followerCount: Int = 0
    var followingCount: Int = 0
    //var profile_pic: String?
    //var first_name: String?
    //var last_name: String?
    //var first_login: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case phone_number
        case postCount
        case username
        case followerCount
        case followingCount
        //case profile_pic
        //case first_name
        //case last_name
    }
}
