//
//  SongRequest.swift
//  GildtApp
//
//  Created by Jeroen Besse on 14/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit

//model created with Pils&Python backendAPI in mind
struct SongRequest: Codable {
    let id: Int
    let artist: String
    let title: String
    var votes: Int
    var datetime: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case artist = "Artist"
        case title = "Title"
        case votes = "Votes"
        case datetime = "DateTime"
    }
    
    //for new songrequest on device
    init(artist: String, title: String) {
        self.id = 0
        self.artist = artist
        self.title = title
        self.votes = 1
        self.datetime = Date()
    }
}
