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
            loadStampData()
        }
    }
    
    @IBOutlet weak var StampLabel: UILabel!
    @IBOutlet weak var StampImage: UIImageView!
    
    func loadStampData() {
        if let stamp = item {
            StampLabel.isHidden = stamp.verifiedAttendance
            StampImage.isHidden = !stamp.verifiedAttendance
            
            StampLabel.text = stamp.eventDateHumanized
        }
    }
}
