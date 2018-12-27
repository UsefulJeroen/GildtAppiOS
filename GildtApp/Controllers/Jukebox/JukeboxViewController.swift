//
//  JukeboxViewController.swift
//  GildtApp
//
//  Created by Jeroen Besse on 14/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class JukeboxViewController: GenericTableViewController<SongRequestTableViewCell, SongRequest> {
    
    override func getCellId() -> String {
        return "SongRequestTableViewCell"
    }
    
    override func getMainAPICall() -> DataRequest {
        return JukeboxAPIService.getSongRequests()
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var artistTextField: UITextField!
    @IBOutlet weak var plusButton: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Jukebox"
        
        setupAddButton()
    }
    
    //add gesturerecognizer to addbutton
    func setupAddButton() {
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addSongButtonTouched))
        plusButton.isUserInteractionEnabled = true
        plusButton.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //override reloadItems to set the row of each songRequest
    override func reloadItems(newData: [SongRequest]) {
        var newItems: [SongRequest] = []
        var i = 1
        for var song in newData {
            song.row = i
            newItems.append(song)
            i += 1
        }
        items = newItems
        finishRefreshing()
    }
    
    //if row is selected; upvote the song
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let row = indexPath.row
//        let song = items[row]
//        JukeboxAPIService.upvoteSong(songId: song.id)
//            .responseData(completionHandler: { [weak self] (response) in
//                guard let jsonData = response.data else { return }
//
//                let decoder = JSONDecoder()
//                let data = try? decoder.decode(SongRequest.self, from: jsonData)
//
//                DispatchQueue.main.async {
//                    if data != nil {
//                        self?.changeUpvote(indexPath: indexPath)
//                    }
//                }
//            })
//    }
    
    func changeUpvote(indexPath: IndexPath) {
        getItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func titleTextFieldDidEnd(_ sender: Any) {
        titleTextField.endEditing(true)
        artistTextField.becomeFirstResponder()
    }

    @IBAction func artistTextFieldDidEnd(_ sender: Any) {
        addSong()
        artistTextField.endEditing(true)
    }
    
    @objc func addSongButtonTouched() {
        addSong()
    }
    
    func addSong() {
        let title = titleTextField.text
        let artist = artistTextField.text
        //check if nil!!??
        if let title = title, let artist = artist {
            let song = NewSong(title: title, artist: artist)
            JukeboxAPIService.addSong(song: song)
                .response(completionHandler: { [weak self] (response) in
                    
                    guard let jsonData = response.data else { return }
                    
                    let decoder = JSONDecoder()
                    let songRequest = try? decoder.decode(SongRequest.self, from: jsonData)
                    
                    DispatchQueue.main.async {
                        if let songRequest = songRequest {
                            self?.successfullyAddedSong(song: songRequest)
                        }
                    }
                })
        }
    }
    
    func successfullyAddedSong(song: SongRequest) {
        //songRequests.append(song)
        tableView.reloadData()
        titleTextField.text = ""
        artistTextField.text = ""
        //make beautifull animation highlight thingy
    }
}
