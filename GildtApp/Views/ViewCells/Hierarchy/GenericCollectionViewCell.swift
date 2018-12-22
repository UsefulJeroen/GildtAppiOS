//
//  GenericCollectionViewCell.swift
//  GildtApp
//
//  Created by Jeroen Besse on 22/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit

//base generic collectionviewcell with model
//to implement; override the didSet of item to set the view
class GenericCollectionViewCell<U>: UICollectionViewCell, GenericViewCell {
    var item: U!
}
