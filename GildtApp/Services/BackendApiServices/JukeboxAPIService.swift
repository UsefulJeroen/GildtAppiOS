//
//  JukeboxAPIService.swift
//  GildtApp
//
//  Created by Jeroen Besse on 03/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import Alamofire

final class JukeboxAPIService: BackendAPIService {
    
    static func getSongRequests() -> DataRequest {
        let endPointURL = "song"
        return createRequest(endPointURL: endPointURL)
    }
    
    static func addSong(song: NewSong) -> DataRequest {
        let endPointURL = "song"
        return createRequest(endPointURL: endPointURL, model: song)
    }
}
