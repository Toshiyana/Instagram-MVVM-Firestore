//
//  UserService.swift
//  Instagram-MVVM-Firestore-CodeBase
//
//  Created by Toshiyana on 2022/02/10.
//

import Firebase

typealias FirestoreCompletion = (Error?) -> Void

struct UserService {
    static func fetchUser(completion: @escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            // print("DEBUG: Snapshot is \(snapshot?.data())")
            guard let dictionary = snapshot?.data() else { return }
            
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchUsers(completion: @escaping([User]) -> Void) {
//        var users = [User]() // pattern1: when not using map
        
        COLLECTION_USERS.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            // -----------------------------------------------------------
            // pattern1: when not using map
            // -----------------------------------------------------------
//            snapshot.documents.forEach { document in
//                // print("DEBUG: Document in service file \(document)")
//                let user = User(dictionary: document.data())
//                users.append(user)
//            }
//
//            completion(users)
            // -----------------------------------------------------------
            
            // -----------------------------------------------------------
            // pattern2: when using map (better, simple)
            // -----------------------------------------------------------
            let users = snapshot.documents.map({ User(dictionary: $0.data() )})
            completion(users)
        }
    }
    
    static func follow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following")
            .document(uid).setData([:]) { error in
                COLLECTION_FOLLOWERS.document(uid).collection("user-followers")
                    .document(currentUid).setData([:], completion: completion)
        }
    }
    
    static func unfollow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following")
            .document(uid).delete { error in
                
                COLLECTION_FOLLOWERS.document(uid).collection("user-followers")
                    .document(currentUid).delete(completion: completion)
            }
    }
    
    static func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following")
            .document(uid).getDocument { (snapshot, error) in
                guard let isFollowed = snapshot?.exists else { return }
                completion(isFollowed)
            }
    }
    
    static func fetchUserStats(uid: String, completion: @escaping(UserStats) -> Void) {
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { (snapshot, error) in
            let followers = snapshot?.documents.count ?? 0
            
            COLLECTION_FOLLOWING.document(uid).collection("user-following").getDocuments { (snapshot, error) in
                let following = snapshot?.documents.count ?? 0
                
                completion(UserStats(followers: followers, following: following))
            }
        }
    }
    
}
