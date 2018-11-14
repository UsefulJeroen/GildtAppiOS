//
//  SongRequestTableViewCell.swift
//  GildtApp
//
//  Created by Jeroen Besse on 14/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit

//custom tableviewcell for jukebox-tableview
class SongRequestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var idLabelView: UITextView!
    @IBOutlet weak var titleLabelView: UITextView!
    @IBOutlet weak var artistLabelView: UITextView!
    @IBOutlet weak var upvotesAmountLabelView: UITextView!
    
    @IBOutlet weak var upvoteButton: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        idLabelView.text = ""
        titleLabelView.text = ""
        artistLabelView.text = ""
        upvotesAmountLabelView.text = ""
    }
}
