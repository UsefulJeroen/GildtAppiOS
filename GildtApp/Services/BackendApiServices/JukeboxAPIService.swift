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
        var request = URLRequest(url: URL(string: "\(baseURL)/song")!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(song)
        let json = String(data: jsonData, encoding: .utf8)
        let data = json?.data(using: .utf8, allowLossyConversion: false)!
        
        request.httpBody = data
        
        if let authToken = LocalStorageService.getAuthToken() {
            request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        return Alamofire.request(request)
    }
}
