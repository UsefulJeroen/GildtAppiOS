//
//  GenericCollectionViewCell.swift
//  GildtApp
//
//  Created by Jeroen Besse on 22/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit

class GenericCollectionViewCell<U>: UICollectionViewCell, GenericViewCell {
    var item: U!
}
