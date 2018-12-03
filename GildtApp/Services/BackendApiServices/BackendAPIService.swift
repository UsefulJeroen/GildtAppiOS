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
class BackendAPIService {
    static let baseURL = "https://gildt.inholland-informatica.nl/api/v1/"
    
    static func getAuthHeaderDict() -> [String: String] {
        var headers: [String: String] = [:]
        if let authToken = LocalStorageService.getAuthToken() {
            headers["Authorization"] = "Bearer \(authToken)"
        }
        return headers
    }
    
    
}
