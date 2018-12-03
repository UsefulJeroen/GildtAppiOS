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
    
    static func register(user: RegisterModel) -> DataRequest {
        let endPointURL = "user"
        return createRequestWithBody(endPointURL: endPointURL, model: user)
    }
    
    static func login(user: LoginModel) -> DataRequest {
        let endPointURL = "user_token"
        return createRequestWithBody(endPointURL: endPointURL, model: user)
    }
}
