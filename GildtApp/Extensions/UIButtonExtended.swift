//
//  UIButtonExtended.swift
//  GildtApp
//
//  Created by Wouter Janson on 05/01/2019.
//  Copyright © 2019 Gildt. All rights reserved.
//

import Foundation
import UIKit

class UIButtonExtended: UIButton {
    var addedTouchArea = CGFloat(0)
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let newBound = CGRect(
            x: self.bounds.origin.x - addedTouchArea,
            y: self.bounds.origin.y - addedTouchArea,
            width: self.bounds.width + 2 * addedTouchArea,
            height: self.bounds.width + 2 * addedTouchArea
        )
        return newBound.contains(point)
    }
}
