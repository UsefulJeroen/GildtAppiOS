//
//  Tag.swift
//  GildtApp
//
//  Created by Jeroen Besse on 10/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation

struct Tag: Codable {
    let id : Int?
    let title : String?
    let preview_image : String?
    let number_of_images : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case title = "title"
        case preview_image = "preview_image"
        case number_of_images = "number_of_images"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        preview_image = try values.decodeIfPresent(String.self, forKey: .preview_image)
        number_of_images = try values.decodeIfPresent(Int.self, forKey: .number_of_images)
    }
    
    init(id: Int, title: String, preview_image: String, number_of_images: Int) {
        self.id = id
        self.title = title
        self.preview_image = preview_image
        self.number_of_images = number_of_images
    }
}
