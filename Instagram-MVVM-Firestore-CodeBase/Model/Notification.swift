//
//  Notification.swift
//  Instagram-MVVM-Firestore-CodeBase
//
//  Created by Toshiyana on 2022/03/07.
//

import FirebaseFirestore

enum NotificationType: Int {
    case like
    case follow
    case comment
    
    var notificationMessage: String {
        switch self {
        case .like: return " liked your post."
        case .follow: return " started following you."
        case .comment: return " commented on your post"
        }
    }
}

struct Notification {
    let id: String
    let uid: String
    let postId: String?
    let postImageUrl: String?
    let timestamp: Timestamp
    let type: NotificationType
    
    init(dictionary: [String: Any]) {
        id = dictionary["id"] as? String ?? ""
        uid = dictionary["uid"] as? String ?? ""
        postId = dictionary["postId"] as? String ?? ""
        postImageUrl = dictionary["postImageUrl"] as? String ?? ""
        timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like
    }
}
