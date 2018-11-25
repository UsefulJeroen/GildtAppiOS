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
    
    enum CodingKeys: String, CodingKey {
        case jwt = "jwt"
    }
}
