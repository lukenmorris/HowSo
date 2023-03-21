//
//  ProfilePictureService.swift
//  howso
//
//  Created by Luke Morris on 3/18/23.
//

import SwiftUI
import Firebase
import FirebaseStorage
import PhotosUI

class profilePictureService: ObservableObject {
    
    private let storage = Storage.storage()
    private let db = Firestore.firestore()
    
    init() {}
    @ObservedObject private var authModel = authService()
    
    func uploadProfilePicture(image: UIImage) {
        let storageRef = storage.reference().child("profilePics/\(authModel.user?.id ?? "")")
        let resizedImage = image.aspectFittedToHeight(200)
        let data = resizedImage.jpegData(compressionQuality: 0.2)
        guard data != nil else {
            return
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        metadata.customMetadata = ["userID": authModel.user?.id ?? ""]
        if let data = data {
            storageRef.putData(data, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error while uploading file: ", error)
                } else {
                    storageRef.downloadURL { url, error in
                        if let downloadURL = url {
                            let db = Firestore.firestore()
                            let userRef = db.collection("users").document(self.authModel.user?.id ?? "")
                            userRef.updateData([
                                "profileImageUrl": downloadURL.absoluteString,
                                /*"profileImageMetadata": [
                                    "size": metadata?.size ?? 0,
                                    "contentType": metadata?.contentType ?? ""
                                 ]*/
                            ])
                        } else if let error = error {
                            print("Error getting download URL: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    func fetchProfileImages(userIds: Set<String>) {
        let db = Firestore.firestore()
        let usersRef = db.collection("users")
        let query = usersRef.whereField("userId", in: Array(userIds))
        
        query.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching user documents: \(error)")
            } else if let documents = snapshot?.documents {
                for document in documents {
                    let userId = document.documentID
                    if let profileImageUrlString = document.data()["profileImageUrl"] as? String,
                        let profileImageUrl = URL(string: profileImageUrlString) {
                        //self.profileImageURLs[userId] = profileImageUrl
                    }
                }
            }
        }
    }
}

