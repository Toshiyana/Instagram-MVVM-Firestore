//
//  File.swift
//  Instagram-MVVM-Firestore-CodeBase
//
//  Created by Toshiyana on 2022/02/04.
//

import UIKit

struct LoginViewModel {
    // these propery are accessed from Controller
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        // computed property
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? .purple : .systemPurple.withAlphaComponent(0.5)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
    
}

struct RegistrationViewModel {
    
}
