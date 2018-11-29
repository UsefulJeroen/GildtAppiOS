//
//  NewSong.swift
//  GildtApp
//
//  Created by Jeroen Besse on 29/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation

struct NewSong: Codable {
    
    let title: String
    let artist: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case artist = "artist"
    }
    
    init(title: String, artist: String) {
        self.title = title
        self.artist = artist
    }
}
