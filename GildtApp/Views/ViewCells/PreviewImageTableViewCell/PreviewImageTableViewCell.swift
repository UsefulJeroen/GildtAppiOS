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
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photo.image = nil
        descriptionLabel.text = ""
    }
}
