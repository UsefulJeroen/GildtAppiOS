//
//  PreviewImage.swift
//  GildtApp
//
//  Created by Jeroen Besse on 13/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit

struct Image: Codable {
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
    }
    
    func getURL() -> URL {
        return URL(string: getURLString())!
    }
    
    func getURLString() -> String {
        return "https://gildt.inholland-informatica.nl" + url
    }
}
