//
//  LoginPostBack.swift
//  GildtApp
//
//  Created by Jeroen Besse on 25/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation

struct LoginPostBack: Codable {
    
    let jwt: String
    let username: String
    let email: String
    let notification: String
    
    enum CodingKeys: String, CodingKey {
        case jwt = "jwt"
        case username = "username"
        case email = "email"
        case notification = "notification"
    }
}
