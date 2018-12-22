//
//  PreviewImageTableViewCell.swift
//  GildtApp
//
//  Created by Jeroen Besse on 13/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit

class PreviewImageTableViewCell: GenericTableViewCell<Photo> {
    
    override var item: Photo! {
        didSet {
            photo.kf.setImage(with: item.image.getURL())
            descriptionLabel.text = item.description
            let date = item.publish_date.toDate(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateStyle = .long
            publishDateLabel.text = "\(formatter.string(from: date))"
        }
    }
    
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
