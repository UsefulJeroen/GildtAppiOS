//
//  JukeboxViewController.swift
//  GildtApp
//
//  Created by Jeroen Besse on 14/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit

//custom tableviewcontroller for jukebox-view in main.storyboard
class JukeboxViewController: UITableViewController {
    
    //fake data, real backendapi should be used in endproduct!
    var songRequests: [SongRequest] = [
        SongRequest(id: 1, artist: "Post Malone", title: "Better Now", votes: 22, datetime: Date()),
        SongRequest(id: 2, artist: "Drake", title: "In My Feelings", votes: 17, datetime: Date()),
        SongRequest(id: 3, artist: "5 Seconds of Summer", title: "Youngblood", votes: 16, datetime: Date()),
        SongRequest(id: 4, artist: "Zware Jongens", title: "De kneu", votes: 16, datetime: Date()),
        SongRequest(id: 5, artist: "Andre Hazes", title: "Bloed, zweet en tranen", votes: 12, datetime: Date()),
        SongRequest(id: 6, artist: "Panic! At the disco", title: "High Hopes", votes: 10, datetime: Date()),
        SongRequest(id: 7, artist: "Bl0f", title: "Harder dan ik hebben kan", votes: 9, datetime: Date()),
        SongRequest(id: 8, artist: "Boney M.", title: "Daddy Cool", votes: 6, datetime: Date()),
        SongRequest(id: 9, artist: "Wham!", title: "Wake me up before you go go", votes: 3, datetime: Date()),
        SongRequest(id: 9, artist: "Wham!", title: "Wake me up before you go go", votes: 3, datetime: Date()),
        SongRequest(id: 9, artist: "Wham!", title: "Wake me up before you go go", votes: 3, datetime: Date()),
        SongRequest(id: 9, artist: "Wham!", title: "Wake me up before you go go", votes: 3, datetime: Date()),
        SongRequest(id: 9, artist: "Wham!", title: "Wake me up before you go go", votes: 3, datetime: Date()),
        SongRequest(id: 9, artist: "Wham!", title: "Wake me up before you go go", votes: 3, datetime: Date()),
        SongRequest(id: 9, artist: "Wham!", title: "Wake me up before you go go", votes: 3, datetime: Date()),
        SongRequest(id: 9, artist: "Wham!", title: "Wake me up before you go go", votes: 3, datetime: Date())
    ]
    
    //can remove?
    var image: UIImage?
    
    private let tableHeaderViewheight: CGFloat = 500.0 // make height of image etc
    private let tableHeaderViewCutaway: CGFloat = 40.0
    
    //is niet nodig, gebruik gewoon die ene image
    //var headerView: DetailHeaderView!
    var headerMaskLayer: CAShapeLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Jukebox"
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SongRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "SongRequestTableViewCell")
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        super.tableView(tableView, numberOfRowsInSection: section)
        return songRequests.count
    }
    
    //set properties for each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongRequestTableViewCell") as! SongRequestTableViewCell
        let row: Int = indexPath.row
        
        cell.idLabelView.text = String(songRequests[row].id)
        cell.titleLabelView.text = songRequests[row].title
        cell.artistLabelView.text = songRequests[row].artist
        cell.upvotesAmountLabelView.text = String(songRequests[row].votes)

        return cell
    }
}
