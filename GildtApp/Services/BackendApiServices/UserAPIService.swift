//
//  UserAPIService.swift
//  GildtApp
//
//  Created by Jeroen Besse on 03/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import Alamofire

final class UserAPIService: BackendAPIService {
    
    static func register(user: RegisterModel) -> DataRequest{
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
}
