//
//  CommentService.swift
//  Instagram-MVVM-Firestore-CodeBase
//
//  Created by Toshiyana on 2022/02/17.
//

import FirebaseFirestore

struct CommentService {
    
    static func uploadComment(comment: String, postID: String, user: User,
                              completion: @escaping(FirestoreCompletion)) {
        
        let data: [String: Any] = ["uid": user.uid,
                                   "comment": comment,
                                   "timestamp": Timestamp(date: Date()),
                                   "username": user.username,
                                   "profileImageUrl": user.profileImageUrl]
        
        COLLECTION_POSTS.document(postID).collection("comments").addDocument(data: data,
                                                                             completion: completion)
    }
    
    static func fetchComments() {
        
    }
}
