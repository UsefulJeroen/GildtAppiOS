//
//  SongRequest.swift
//  GildtApp
//
//  Created by Jeroen Besse on 14/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit

struct SongRequest: Codable {
    let id: Int
    let artist: String
    let title: String
    var votes: Int
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case artist = "artist"
        case title = "title"
        case votes = "votes"
        case userId = "user_id"
    }
    
    //for new songrequest on device
    init(id: Int, artist: String, title: String, votes: Int, userId: Int) {
        self.id = id
        self.artist = artist
        self.title = title
        self.votes = votes
        self.userId = userId
    }
}
