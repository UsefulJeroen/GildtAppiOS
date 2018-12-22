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
    
    override var item: Tag! {
        didSet {
            previewImage.kf.setImage(with: item.preview_image?.getURL())
            titleTextView.text = item.title
            amountPhotosTextView.text = String(item.number_of_images ?? 0)
        }
    }
    
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var amountPhotosTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        previewImage.image = nil
        titleTextView.text = ""
        amountPhotosTextView.text = ""
    }
}
