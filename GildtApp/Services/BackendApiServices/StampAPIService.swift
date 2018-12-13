//
//  StampAPIService.swift
//  GildtApp
//
//  Created by Wouter Janson on 11/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import Alamofire

final class StampAPIService: BackendAPIService {
    
    static func getStamps() -> DataRequest {
        let headers = getAuthHeaderDict()
        return Alamofire.request("\(baseURL)/stamp_card", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
    }
    
    static func claimStamp(qrCode: String) -> DataRequest {
        let headers = getAuthHeaderDict()
        return Alamofire.request("\(baseURL)/stamp_card/\(qrCode)", method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers)
    }
}
