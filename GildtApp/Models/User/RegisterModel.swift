//
//  RegisterModel.swift
//  GildtApp
//
//  Created by Jeroen Besse on 25/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation

struct RegisterModel: Codable {
    
    let username: String
    let email: String
    let password: String
    let password_confirmation: String
    
    init(username: String, email: String, password: String, password_confirmation: String) {
        self.username = username
        self.email = email
        self.password = password
        self.password_confirmation = password_confirmation
    }
}
