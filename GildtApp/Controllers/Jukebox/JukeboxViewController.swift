//
//  JukeboxViewController.swift
//  GildtApp
//
//  Created by Jeroen Besse on 14/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit

class JukeboxViewController: GenericTableViewController<SongRequestTableViewCell, (songRequest: SongRequest, row: Int)> {
    
    //var songRequests: [SongRequest] = []
    override func getCellId() -> String {
        return "SongRequestTableViewCell"
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var artistTextField: UITextField!
    @IBOutlet weak var plusButton: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Jukebox"
        
        setupTableView()
        getSongRequests()
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setupTableView() {
        tableView.dataSource = self
        //tableView.register(UINib(nibName: "SongRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "SongRequestTableViewCell")
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addSongButtonTouched))
        plusButton.isUserInteractionEnabled = true
        plusButton.addGestureRecognizer(tapGestureRecognizer)
        //can remove these 2 lines?
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @objc func getSongRequests() {
        JukeboxAPIService.getSongRequests()
            .responseData(completionHandler: { [weak self] (response) in
                guard let jsonData = response.data else { return }
                
                let decoder = JSONDecoder()
                let data = try? decoder.decode([SongRequest].self, from: jsonData)
                
                DispatchQueue.main.async {
                    if data != nil {
                        self?.reloadSongRequests(newData: data!)
                    }
                }
            })
    }
    
    func reloadSongRequests(newData: [SongRequest]) {
        newData.forEach( { song in
            items.append((song, 1))
        })
        //items = newData
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.refreshControl?.alpha = 0
            self.refreshControl?.endRefreshing()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.refreshControl?.alpha = 1
        })
    }
    
    @objc func refresh() {
        refreshControl?.alpha = 1
        getSongRequests()
    }
    
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        super.tableView(tableView, numberOfRowsInSection: section)
//        return songRequests.count
//    }
    
//    //set properties for each row
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        super.tableView(tableView, cellForRowAt: indexPath)
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SongRequestTableViewCell") as! SongRequestTableViewCell
//        let songRequest = songRequests[indexPath.row]
//
//        cell.idLabelView.text = String(indexPath.row+1)
//        cell.titleLabelView.text = songRequest.title
//        cell.artistLabelView.text = songRequest.artist
//        cell.upvotesAmountLabelView.text = String(songRequest.votes)
//
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let song = items[row]
        JukeboxAPIService.upvoteSong(songId: song.songRequest.id)
            .responseData(completionHandler: { [weak self] (response) in
                guard let jsonData = response.data else { return }
                
                let decoder = JSONDecoder()
                let data = try? decoder.decode(SongRequest.self, from: jsonData)
                
                DispatchQueue.main.async {
                    if data != nil {
                        self?.changeUpvote(indexPath: indexPath)
                    }
                }
            })
    }
    
    func changeUpvote(indexPath: IndexPath) {
        getSongRequests()
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
