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
    init(id: Int, artist: String, title: String, votes: Int, datetime: Date) {
        self.id = id
        self.artist = artist
        self.title = title
        self.votes = votes
        self.datetime = datetime
    }
}
