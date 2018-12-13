//
//  PreviewImageTableViewCell.swift
//  GildtApp
//
//  Created by Jeroen Besse on 13/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit

class PreviewImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        container.layer.cornerRadius = 10
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOffset = CGSize(width: 0, height: 3)
        container.layer.shadowRadius = 14
        container.layer.shadowOpacity = 0.16
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photo.image = nil
        descriptionLabel.text = ""
        publishDateLabel.text = ""
    }
}
