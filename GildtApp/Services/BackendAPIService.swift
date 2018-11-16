//
//  BackendAPIService.swift
//  GildtApp
//
//  Created by Jeroen Besse on 14/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import Alamofire

//bakendapiservice to implement alamofire requests
//this will depend on the api made by Erik,
//possibly changed if an api from an apigroup is available at launch
final class BackendAPIService {
    private static let baseURL = "http://146.185.156.30/api/v1/"
    
    static func getSongs() -> DataRequest {
        var headers: [String: String] = [:]
        if let authToken = LocalStorageService.getAuthToken() {
            headers["x-authtoken"] = authToken
        }
        return Alamofire.request("\(baseURL)/song", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
    }
}
