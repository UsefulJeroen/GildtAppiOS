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
        let endPointURL = "stamp_card"
        return createRequest(endPointURL: endPointURL)
    }
    
    static func claimStamp(qrCode: String) -> DataRequest {
        let endPointURL = "stamp_card/\(qrCode)"
        return createRequest(endPointURL: endPointURL)
    }
}
