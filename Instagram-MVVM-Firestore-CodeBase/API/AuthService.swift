//
//  AuthService.swift
//  Instagram-MVVM-Firestore-CodeBase
//
//  Created by Toshiyana on 2022/02/07.
//

import Foundation
import UIKit

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static func registerUser(withCredential credentials: AuthCredentials) {
        print("DEBUG: Credentials are \(credentials)")
    }
}
