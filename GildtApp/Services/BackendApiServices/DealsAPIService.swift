//
//  DealsAPIService.swift
//  GildtApp
//
//  Created by Wouter Janson on 28/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import Alamofire

final class DealsAPIService: BackendAPIService {

    static func getDeals() -> DataRequest {
        let headers = getAuthHeaderDict()
        return Alamofire.request("\(baseURL)/deal", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
    }

    static func redeemDeal(deal: Deal) -> DataRequest {
        let headers = getAuthHeaderDict()
        return Alamofire.request("\(baseURL)/deal/\(deal.id)/redeem", method: .put, parameters: nil, encoding: URLEncoding.default, headers: headers)
    }
}
