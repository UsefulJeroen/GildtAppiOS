//
//  ErrorMessage.swift
//  GildtApp
//
//  Created by Jeroen Besse on 17/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation

struct ErrorMessage {
    
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
    }
}
