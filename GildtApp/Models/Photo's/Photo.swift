//
//  Photo.swift
//  GildtApp
//
//  Created by Jeroen Besse on 10/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation

struct Photo: Codable {
    let description: String
    let image: Image
    let publish_date: String
    let publisher: String
    
    enum CodingKeys: String, CodingKey {
        case description = "description"
        case image = "image"
        case publish_date = "publish_date"
        case publisher = "publisher"
    }
}
