//
//  GenericController.swift
//  GildtApp
//
//  Created by Jeroen Besse on 22/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

protocol GenericController {
    
    associatedtype type
    
    var items: [type] { get set }
    
    func getCellId() -> String
    
    func getMainAPICall() -> DataRequest?
    
    func getItems()
    
    func reloadItems(newData: [type])
}

extension GenericController {
    
    func getCellId() -> String {
        print("Error: implement getCellId from GenericTableViewController!")
        return "CellId"
    }
    
    func getMainAPICall() -> DataRequest? {
        print("Error: implement getMainAPICall from GenericTableViewController!")
        return nil
    }
}
