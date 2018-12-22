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
class SongRequestTableViewCell: GenericTableViewCell<(songRequest: SongRequest, row: Int)> {
    
    override var item: (songRequest: SongRequest, row: Int)! {
        didSet {
            idLabelView.text = String(item.row)
            titleLabelView.text = item.songRequest.title
            artistLabelView.text = item.songRequest.artist
            upvotesAmountLabelView.text = String(item.songRequest.votes)
        }
    }
    
    @IBOutlet weak var idLabelView: UILabel!
    @IBOutlet weak var titleLabelView: UILabel!
    @IBOutlet weak var artistLabelView: UILabel!
    @IBOutlet weak var upvotesAmountLabelView: UILabel!
    
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
