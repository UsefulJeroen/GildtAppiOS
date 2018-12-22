//
//  GenericCollectionViewController.swift
//  GildtApp
//
//  Created by Jeroen Besse on 22/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class GenericCollectionViewController<T: GenericCollectionViewCell<U>, U>: UICollectionViewController where U: Decodable {
    
    var items = [U]()
    
    func getCellId() -> String {
        print("Error: implement getCellId from GenericCollectionViewController!")
        return "CellId"
    }
    
    func getMainAPICall() -> DataRequest? {
        print("Error: implement getMainAPICall from GeneriCollectionViewController")
        return nil
    }
    
    override func viewDidLoad() {
        collectionView.register(UINib(nibName: getCellId(), bundle: nil), forCellWithReuseIdentifier: getCellId())

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getCellId(), for: indexPath) as! GenericCollectionViewCell<U>
        cell.item = items[indexPath.row]
        return cell
    }
}
