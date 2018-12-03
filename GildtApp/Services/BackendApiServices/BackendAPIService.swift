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
    static let baseURL = "https://gildt.inholland-informatica.nl/api/v1"
    
    static func getAuthHeaderDict() -> [String: String] {
        var headers: [String: String] = [:]
        if let authToken = LocalStorageService.getAuthToken() {
            headers["Authorization"] = "Bearer \(authToken)"
        }
        return headers
    }
    
    static func createRequestWithBody<T>(endPointURL: String, model: T) -> DataRequest where T: Encodable {
        var request = URLRequest(url: URL(string: "\(baseURL)/\(endPointURL)")!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let authToken = LocalStorageService.getAuthToken() {
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(model)
        let json = String(data: jsonData, encoding: .utf8)
        let data = json?.data(using: .utf8, allowLossyConversion: false)!
        request.httpBody = data
        return Alamofire.request(request)
    }
}
