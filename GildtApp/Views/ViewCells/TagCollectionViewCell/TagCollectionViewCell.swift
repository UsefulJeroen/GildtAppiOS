//
//  TagCollectionViewCell.swift
//  GildtApp
//
//  Created by Jeroen Besse on 10/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit

class TagCollectionViewCell: GenericCollectionViewCell<Tag> {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountPhotosLabel: UILabel!
    
    override var item: Tag! {
        didSet {
            previewImage.kf.setImage(with: item.preview_image?.getURL())
            titleLabel.text = item.title
            amountPhotosLabel.text = String(item.number_of_images ?? 0)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        container.layer.cornerRadius = 10
        //self.selectionStyle = .none
        
        // Shaddow is iffy
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOffset = CGSize(width: 0, height: 3)
        container.layer.shadowRadius = 14
        container.layer.shadowOpacity = 0.16
        container.layer.masksToBounds = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        previewImage.image = nil
        titleLabel.text = ""
        amountPhotosLabel.text = ""
    }
}
