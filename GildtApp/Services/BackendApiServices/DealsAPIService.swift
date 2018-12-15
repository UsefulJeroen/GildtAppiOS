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
        let endPointURL = "deal"
        return createRequest(endPointURL: endPointURL)
    }

    static func redeemDeal(deal: Deal) -> DataRequest {
        let endPointURL = "deal/\(deal.id)/redeem"
        return createRequest(endPointURL: endPointURL)
    }
}
