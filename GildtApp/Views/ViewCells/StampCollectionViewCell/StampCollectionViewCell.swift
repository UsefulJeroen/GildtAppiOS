//
//  StampCollectionViewCell.swift
//  GildtApp
//
//  Created by Wouter Janson on 11/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit

class StampCollectionViewCell : GenericCollectionViewCell<Stamp> {
    
    override var item: Stamp! {
        didSet {
            setupView()
            loadStampData()
        }
    }
    
    @IBOutlet weak var StampLabel: UILabel!
    @IBOutlet weak var StampImage: UIImageView!
    
    func setupView() {
        self.layer.cornerRadius = 10
        let templateImage = StampImage.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        StampImage.image = templateImage
        StampImage.tintColor = UIColor.black
    }
    
    func loadStampData() {
        if let stamp = item {
            StampLabel.isHidden = stamp.verifiedAttendance
            StampImage.isHidden = !stamp.verifiedAttendance
            StampImage.rotate(angle: Int.random(in: -50 ... 50))
            StampImage.alpha = CGFloat.random(in: 0.4 ... 0.8)
            StampLabel.text = stamp.eventDateHumanized
        }
    }
}
