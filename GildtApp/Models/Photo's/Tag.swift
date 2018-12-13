//
//  Tag.swift
//  GildtApp
//
//  Created by Jeroen Besse on 10/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation

struct Tag: Codable {
    let id : Int
    let title : String?
    let preview_image : Image?
    let number_of_images : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case title = "title"
        case preview_image = "preview_image"
        case number_of_images = "number_of_images"
    }
}
