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
    
    //fake data, real backendapi should be used!
    var songRequests: [SongRequest] = [SongRequest(artist: "Post Malone", title: "Better Now")]
    
    //can remove?
    var image: UIImage?
    
    private let tableHeaderViewheight: CGFloat = 500.0
    private let tableHeaderViewCutaway: CGFloat = 40.0
    
    //var headerView: DetailHeaderView!
    //var headerMaskLayer: CASHapeLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Jukebox"
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupTableView() {
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SongRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "SongRequestTableViewCell")
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
