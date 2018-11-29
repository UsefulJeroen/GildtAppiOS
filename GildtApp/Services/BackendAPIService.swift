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
    
    static func createUser(user: RegisterModel) -> DataRequest{
        var request = URLRequest(url: URL(string: "\(baseURL)/user")!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(user)
        let json = String(data: jsonData, encoding: .utf8)
        let data = json?.data(using: .utf8, allowLossyConversion: false)!
        
        request.httpBody = data
        
        return Alamofire.request(request)
    }
    
    static func login(user: LoginModel) -> DataRequest {
        var request = URLRequest(url: URL(string: "\(baseURL)/user_token")!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(user)
        let json = String(data: jsonData, encoding: .utf8)
        let data = json?.data(using: .utf8, allowLossyConversion: false)!
        
        request.httpBody = data
        
        return Alamofire.request(request)
    }
    
    static func getSongRequests() -> DataRequest {
        var headers: [String: String] = [:]
        if let authToken = LocalStorageService.getAuthToken() {
            headers["Authorization"] = "Bearer \(authToken)"
        }
        return Alamofire.request("\(baseURL)/song", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
    }
}
