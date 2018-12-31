//
//  UIView.swift
//  GildtApp
//
//  Created by Wouter Janson on 31/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func rotate(angle: Int) {
        let radians = CGFloat(angle) / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians)
        self.transform = rotation
    }
}
