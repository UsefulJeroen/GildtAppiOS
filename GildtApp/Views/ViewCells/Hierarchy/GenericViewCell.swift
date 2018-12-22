//
//  GenericViewCell.swift
//  GildtApp
//
//  Created by Jeroen Besse on 22/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation

protocol GenericViewCell {
    associatedtype type
    var item: type! { get set }
}
