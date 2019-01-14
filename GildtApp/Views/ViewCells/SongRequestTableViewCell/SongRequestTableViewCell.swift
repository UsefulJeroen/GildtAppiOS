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
            if item.didVote == .downvote {
                setDownvoted()
            }
            if item.didVote == .upvote {
                setUpvoted()
            }
            if item.new == true {
                setNew()
            }
        }
    }
    
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var idImageView: UIImageView!
    @IBOutlet weak var idLabelView: UILabel!
    @IBOutlet weak var titleLabelView: UILabel!
    @IBOutlet weak var artistLabelView: UILabel!
    @IBOutlet weak var upvotesAmountLabelView: UILabel!
    
    @IBOutlet weak var downvoteButton: UIButton!
    @IBOutlet weak var upvoteButton: UIButton!
    
    func setUpvoted() {
        upvotesAmountLabelView.textColor = UIColor.primaryGildtGreen
        upvoteButton.setImage(UIImage(named: "arrow-up-green"), for: UIControl.State.normal)
    }
    
    func setDownvoted() {
        upvotesAmountLabelView.textColor = UIColor.red
        downvoteButton.setImage(UIImage(named: "arrow-down-red"), for: UIControl.State.normal)
    }
    
    func setNew() {
        container.backgroundColor = .white
        titleLabelView.backgroundColor = .white
        artistLabelView.backgroundColor = .white
        idImageView.image = UIImage(named: "SongRequestCircleImageGreen")
        idLabelView.text = NSLocalizedString("Jukebox_New", comment: "")
        idLabelView.textColor = .white
        
        container.layer.cornerRadius = 10
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOffset = CGSize(width: 0, height: 3)
        container.layer.shadowRadius = 14
        container.layer.shadowOpacity = 0.16
        container.layer.masksToBounds = false
    }
    
    @objc func downvoteClicked(_ sender: UIButton?) {
        GildtAPIService.downvoteSong(songId: item.id)
            .responseData(completionHandler: { [weak self] (response) in
                guard let jsonData = response.data else { return }
                
                let decoder = JSONDecoder()
                let data = try? decoder.decode(SongRequest.self, from: jsonData)
                
                DispatchQueue.main.async {
                    if let data = data {
                        if data.id == self?.item.id {
                            self?.successfullyVoted(updatedSongrequest: data)
                        }
                    }
                }
            })
    }
    
    @objc func upvoteButtonClicked(_ sender: UIButton?) {
        GildtAPIService.upvoteSong(songId: item.id)
            .responseData(completionHandler: { [weak self] (response) in
                guard let jsonData = response.data else { return }
                
                let decoder = JSONDecoder()
                let data = try? decoder.decode(SongRequest.self, from: jsonData)
                
                DispatchQueue.main.async {
                    if let data = data {
                        if data.id == self?.item.id {
                            self?.successfullyVoted(updatedSongrequest: data)
                        }
                    }
                }
            })
    }
    
    func successfullyVoted(updatedSongrequest: SongRequest) {
        upvotesAmountLabelView.text = ""
        upvotesAmountLabelView.textColor = UIColor.black
        upvoteButton.setImage(UIImage(named: "arrow-up-grey"), for: UIControl.State.normal)
        downvoteButton.setImage(UIImage(named: "arrow-down-grey"), for: UIControl.State.normal)
        item = updatedSongrequest
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
        upvotesAmountLabelView.textColor = UIColor.black
        upvoteButton.setImage(UIImage(named: "arrow-up-grey"), for: UIControl.State.normal)
        downvoteButton.setImage(UIImage(named: "arrow-down-grey"), for: UIControl.State.normal)
        container.backgroundColor = .appBackground
        container.layer.cornerRadius = 0
        container.layer.shadowRadius = 0
        container.layer.shadowOpacity = 0
        titleLabelView.backgroundColor = .appBackground
        artistLabelView.backgroundColor = .appBackground
        idImageView.image = UIImage(named: "SongRequestCircleImageWhite")
        idLabelView.textColor = .black
        //container.layer.cornerRadius = 0
    }
}
