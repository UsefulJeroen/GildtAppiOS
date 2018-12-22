//
//  StampCollectionViewCell.swift
//  GildtApp
//
//  Created by Wouter Janson on 11/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit

class StampCollectionViewCell : UICollectionViewCell {
    var stamp: Stamp? = nil
    
    @IBOutlet weak var StampLabel: UILabel!
    @IBOutlet weak var StampImage: UIImageView!
    
    func setupView() {
        self.layer.cornerRadius = 10
    }
    
    func loadStampData() {
        if let stamp = stamp {
            StampLabel.isHidden = stamp.verifiedAttendance
            StampImage.isHidden = !stamp.verifiedAttendance
            
            StampLabel.text = stamp.eventDateHumanized
        }
    }
}
