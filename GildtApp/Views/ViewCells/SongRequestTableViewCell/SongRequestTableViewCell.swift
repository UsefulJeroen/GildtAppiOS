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
    
    var songRequestId: Int?
    
    @IBOutlet weak var idLabelView: UILabel!
    @IBOutlet weak var titleLabelView: UILabel!
    @IBOutlet weak var artistLabelView: UILabel!
    @IBOutlet weak var upvotesAmountLabelView: UILabel!
    
    @IBOutlet weak var upvoteButton: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let upvoteRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.upvoteSongRequest(sender:)))
        upvoteRecognizer.delegate = self
        upvoteButton.addGestureRecognizer(upvoteRecognizer)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        idLabelView.text = ""
        titleLabelView.text = ""
        artistLabelView.text = ""
        upvotesAmountLabelView.text = ""
    }
    
    @objc func upvoteSongRequest(sender: UITapGestureRecognizer? = nil) {
        if let songRequestId = songRequestId {
            JukeboxAPIService.upvoteSong(songId: songRequestId)
                .responseData(completionHandler: { [weak self] (response) in
                    DispatchQueue.main.async {
                        self?.changeUpvote()
                    }
                })
        }
    }
    
    func changeUpvote() {
        //change image to new image that is selected
        NotificationCenter.default.post(name: Notification.Name("ReloadSongRequests"), object: nil, userInfo: nil)
    }
}
