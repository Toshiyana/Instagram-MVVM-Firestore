//
//  Constants.swift
//  Instagram-MVVM-Firestore-CodeBase
//
//  Created by Toshiyana on 2022/02/10.
//

import FirebaseFirestore

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")
