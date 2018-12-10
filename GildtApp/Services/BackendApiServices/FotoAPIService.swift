//
//  FotoAPIService.swift
//  GildtApp
//
//  Created by Jeroen Besse on 10/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import Alamofire

final class FotoAPIService: BackendAPIService {
    
    static func getAllTags() -> DataRequest {
        let headers = getAuthHeaderDict()
        return Alamofire.request("\(baseURL)/tag", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
    }
    
    static func getImagesFromTag(id: Int) -> DataRequest {
        let headers = getAuthHeaderDict()
        return Alamofire.request("\(baseURL)/tag/\(id)/images", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
    }
}
