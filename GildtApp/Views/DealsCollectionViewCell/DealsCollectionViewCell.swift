//
//  DealsCollectionViewCell.swift
//  GildtApp
//
//  Created by Wouter Janson on 18/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import UIKit

class DealsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var DealImage: UIImageView!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var Usability: UILabel!
    @IBOutlet weak var GreenBar: UIView!
    @IBOutlet weak var Availability: UILabel!
    
    func setUpView() {
        // corner radiusus
        self.layer.cornerRadius = 10
        DealImage.layer.cornerRadius = 15
        GreenBar.layer.cornerRadius = 10
        GreenBar.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        // shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.layer.shadowRadius = 14
        self.layer.shadowOpacity = 0.16
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}
