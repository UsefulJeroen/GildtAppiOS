//
//  LoginModel.swift
//  GildtApp
//
//  Created by Jeroen Besse on 25/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation

struct LoginModel: Codable {
    
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case password = "password"
    }
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
