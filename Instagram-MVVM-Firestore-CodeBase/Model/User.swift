//
//  User.swift
//  Instagram-MVVM-Firestore-CodeBase
//
//  Created by Toshiyana on 2022/02/10.
//

import Firebase

struct User {
    let email: String
    let fullname: String
    let profileImageUrl: String
    let username: String
    let uid: String
    
    var isFollowed = false
    
    var stats: UserStats!
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(dictionary: [String: Any]) {
        email = dictionary["email"] as? String ?? ""
        fullname = dictionary["fullname"] as? String ?? ""
        profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        username = dictionary["username"] as? String ?? ""
        uid = dictionary["uid"] as? String ?? ""
        
        stats = UserStats(followers: 0, following: 0) // set default value, because stats type is "UserStats!", force unwrapping
    }
}

struct UserStats {
    var followers: Int
    var following: Int
//    let posts: Int
}
