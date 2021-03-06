//
//  PostService.swift
//  Instagram-MVVM-Firestore-CodeBase
//
//  Created by Toshiyana on 2022/02/13.
//

import FirebaseFirestore
import Firebase
import UIKit

struct PostService {
    
    static func uploadPost(caption: String, image: UIImage, user: User, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { imageUrl in
            let data: [String: Any] = ["caption": caption,
                                       "timestamp": Timestamp(date: Date()),
                                       "likes": 0,
                                       "imageUrl": imageUrl,
                                       "ownerUid": uid,
                                       "ownerImageUrl": user.profileImageUrl,
                                       "ownerUsername": user.username]
            
            let docRef = COLLECTION_POSTS.addDocument(data: data, completion: completion)
            
            self.updateUserFeedAfterPost(postId: docRef.documentID)
        }
    }
    
    static func fetchPosts(completion: @escaping([Post]) -> Void) {
        COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments { (snapshot, error) in
            guard let document = snapshot?.documents else { return }
            
            let posts = document.map({ Post(postId: $0.documentID, dictionary: $0.data()) })
            completion(posts)
        }
    }
    
    static func fetchPosts(forUser uid: String, completion: @escaping([Post]) -> Void) {
        let query = COLLECTION_POSTS
            .whereField("ownerUid", isEqualTo: uid) // can't use order() when using ".whereField()"
        
        query.getDocuments { (snapshot, error) in
            guard let document = snapshot?.documents else { return }
            
            var posts = document.map({ Post(postId: $0.documentID, dictionary: $0.data()) })
            
            // sort using timestamp after get data
            posts.sort(by: { $0.timestamp.seconds > $1.timestamp.seconds})
//            posts.sort { (post1, post2) -> Bool in
//                return post1.timestamp.seconds > post2.timestamp.seconds
//            }
            
            completion(posts)
        }
    }
    
    static func fetchPost(withPostId postId: String, completion: @escaping(Post) -> Void) {
        COLLECTION_POSTS.document(postId).getDocument { snapshot, _ in
            guard let snapshot = snapshot else { return }
            guard let data = snapshot.data() else { return }
            let post = Post(postId: snapshot.documentID, dictionary: data)
            completion(post)
        }
    }
    
    static func likePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_POSTS.document(post.postId).updateData(["likes": post.likes + 1])
        
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(uid)
            .setData([:]) { error in
            
                COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId)
                    .setData([:], completion: completion)
        
            }
    }
    
    static func unlikePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard post.likes > 0 else { return }
        
        COLLECTION_POSTS.document(post.postId).updateData(["likes": post.likes - 1])
        
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(uid)
            .delete { error in
                
                COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId)
                    .delete(completion: completion)
            }
    }
    
    static func checkIfUserLikePost(post: Post, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId)
            .getDocument { (snapshot, error) in
                guard let didLike = snapshot?.exists else { return }
                completion(didLike)
            }
    }
    
    static func fetchFeedPosts(completion: @escaping([Post]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var posts = [Post]()
        
        COLLECTION_USERS.document(uid).collection("user-feed").getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                fetchPost(withPostId: document.documentID) { post in
                    posts.append(post)
                    
                    // sort using timestamp after get data
                    posts.sort(by: { $0.timestamp.seconds > $1.timestamp.seconds})
//                    posts.sort { (post1, post2) -> Bool in
//                        return post1.timestamp.seconds > post2.timestamp.seconds
//                    }
                    
                    completion(posts)
                }
            })
        }
    }
    
    static func updateUserFeedAfterFollowing(user: User, didFollow: Bool) {
        // This is not best way to efficiently update Feed following.
        // you can improve with full code on shop. (use cloud fuction)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_POSTS.whereField("ownerUid", isEqualTo: user.uid)
        query.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            
            let docIDs = documents.map({ $0.documentID })

            docIDs.forEach { id in
                if didFollow {
                    // Saving all id of feed following as array is not good.
                    COLLECTION_USERS.document(uid).collection("user-feed").document(id).setData([:])
                } else {
                    COLLECTION_USERS.document(uid).collection("user-feed").document(id).delete()
                }
            }
        }
    }
    
    private static func updateUserFeedAfterPost(postId: String) {
        // This is not best way to efficiently update Feed following.
        // you can improve with full code on shop. (use cloud fuction)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            
            documents.forEach { document in
                COLLECTION_USERS.document(document.documentID).collection("user-feed").document(postId).setData([:])
            }
            
            COLLECTION_USERS.document(uid).collection("user-feed").document(postId).setData([:])
        }
    }
}
