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

class messageService: ObservableObject {
    @Published var conversations = [Conversation]()
}
