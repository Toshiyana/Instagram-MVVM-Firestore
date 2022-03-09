//
//  NotificationService.swift
//  Instagram-MVVM-Firestore-CodeBase
//
//  Created by Toshiyana on 2022/03/07.
//

import Firebase
import FirebaseFirestore

struct NotificationService {
    
    static func uploadNotification(toUid uid: String, fromUser: User, type: NotificationType, post: Post? = nil) {
        // if you use "user: User" as parameter, you don't have to use "uid", "profileImageUrl", and "username".
        // However, we choose cost efficency than code efficency by duplicating data in firestore.
        // When you use "user: User", you have to request firestore two times.
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard uid != currentUid else { return }
        
        let docRef = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").document()
        
        var data: [String: Any] = ["timestamp": Timestamp(date: Date()),
                                   "uid": fromUser.uid,
                                   "type": type.rawValue,
                                   "id": docRef.documentID,
                                   "userProfileImageUrl": fromUser.profileImageUrl,
                                   "username": fromUser.username]
        
        // when "type" param is not ".like", don't have "post" param
        if let post = post {
            data["postId"] = post.postId
            data["postImageUrl"] = post.imageUrl
        }
        
        docRef.setData(data)
    }
    
    static func fetchNotifications(completion: @escaping([Notification]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications")
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let notifications = documents.map({ Notification(dictionary: $0.data()) })
                completion(notifications)
            }
    }
}
