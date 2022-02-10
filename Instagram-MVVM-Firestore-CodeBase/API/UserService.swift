//
//  UserService.swift
//  Instagram-MVVM-Firestore-CodeBase
//
//  Created by Toshiyana on 2022/02/10.
//

import Firebase

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
}
