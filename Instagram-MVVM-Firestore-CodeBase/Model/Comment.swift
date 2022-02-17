//
//  Comment.swift
//  Instagram-MVVM-Firestore-CodeBase
//
//  Created by Toshiyana on 2022/02/17.
//

import FirebaseFirestore

struct Comment {
    let uid: String
    let username: String
    let profileImageUrl: String
    let timestamp: Timestamp
    let commentText: String
    
    init(dictionary: [String: Any]) {
        uid = dictionary["uid"] as? String ?? ""
        username = dictionary["username"] as? String ?? ""
        profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        commentText = dictionary["comment"] as? String ?? ""
        timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
