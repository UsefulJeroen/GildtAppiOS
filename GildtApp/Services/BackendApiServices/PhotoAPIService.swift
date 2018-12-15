//
//  PhotoAPIService.swift
//  GildtApp
//
//  Created by Jeroen Besse on 10/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import Alamofire

final class PhotoAPIService: BackendAPIService {
    
    static func getAllTags() -> DataRequest {
        let endPointURL = "tag"
        return createRequest(endPointURL: endPointURL)
    }
    
    static func getImagesFromTag(id: Int) -> DataRequest {
        let endPointURL = "tag/\(id)/images"
        return createRequest(endPointURL: endPointURL)
    }
}
