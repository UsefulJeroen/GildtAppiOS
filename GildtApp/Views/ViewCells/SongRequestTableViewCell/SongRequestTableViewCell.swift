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
class SongRequestTableViewCell: GenericTableViewCell<SongRequest> {
    
    override var item: SongRequest! {
        didSet {
            if let row = item.row {
                idLabelView.text = String(row)
            }
            titleLabelView.text = item.title
            artistLabelView.text = item.artist
            upvotesAmountLabelView.text = String(item.votes)
            if item.didVote == -1 {
                setDownvoted()
            }
            if item.didVote == 1 {
                setUpvoted()
            }
        }
    }
    
    @IBOutlet weak var idLabelView: UILabel!
    @IBOutlet weak var titleLabelView: UILabel!
    @IBOutlet weak var artistLabelView: UILabel!
    @IBOutlet weak var upvotesAmountLabelView: UILabel!
    
    @IBOutlet weak var downvoteButton: UIButton!
    @IBOutlet weak var upvoteButton: UIButton!
    
    func setUpvoted() {
        upvotesAmountLabelView.textColor = UIColor.green
        upvoteButton.setImage(UIImage(named: "arrow-up-green"), for: UIControl.State.normal)
    }
    
    func setDownvoted() {
        upvotesAmountLabelView.textColor = UIColor.red
        downvoteButton.setImage(UIImage(named: "arrow-down-red"), for: UIControl.State.normal)
    }
    
    @objc func downvoteClicked(_ sender: UIButton?) {
        
    }
    
    @objc func upvoteButtonClicked(_ sender: UIButton?) {
        print("upvote clicked")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        downvoteButton.addTarget(self, action:#selector(self.downvoteClicked(_:)), for: .touchUpInside)
        upvoteButton.addTarget(self, action:#selector(self.upvoteButtonClicked(_:)), for: .touchUpInside)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        idLabelView.text = ""
        titleLabelView.text = ""
        artistLabelView.text = ""
        upvotesAmountLabelView.text = ""
        upvoteButton.setImage(UIImage(named: "arrow-up-grey"), for: UIControl.State.normal)
        downvoteButton.setImage(UIImage(named: "arrow-up-grey"), for: UIControl.State.normal)
    }
}
