//
//  Post.swift
//  Instagram-MVVM-Firestore-CodeBase
//
//  Created by Toshiyana on 2022/02/14.
//

import FirebaseFirestore

struct Post {
    let postId: String
    var caption: String
    var likes: Int
    let imageUrl: String
    let ownerUid: String
    let timestamp: Timestamp
    let ownerImageUrl: String
    let ownerUsername: String
    
    init(postId: String, dictionary: [String: Any]) {
        self.postId = postId
        caption = dictionary["caption"] as? String ?? ""
        likes = dictionary["likes"] as? Int ?? 0
        imageUrl = dictionary["imageUrl"] as? String ?? ""
        ownerUid = dictionary["ownerUid"] as? String ?? ""
        timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        ownerImageUrl = dictionary["ownerImageUrl"] as? String ?? ""
        ownerUsername = dictionary["ownerUsername"] as? String ?? ""
    }
}
