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
        let headers = getAuthHeaderDict()
        return Alamofire.request("\(baseURL)/song", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
    }
    
    static func addSong(song: NewSong) -> DataRequest {
        let endPointURL = "song"
        return createRequestWithBody(endPointURL: endPointURL, model: song)
    }
}
