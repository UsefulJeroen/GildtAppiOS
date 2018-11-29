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
    
    var pendingNetworkRequest: Bool = false
    
    var songRequests: [SongRequest] = []
    
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
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SongRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "SongRequestTableViewCell")
        //can remove these 2 lines?
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func getSongRequests() {
        pendingNetworkRequest = true
        BackendAPIService.getSongRequests()
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
        pendingNetworkRequest = false
    }
    
    func reloadSongRequests(newData: [SongRequest]) {
        songRequests = newData
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
    
    @IBAction func titleTextFieldDidEnd(_ sender: Any) {
        //var verycool = "something"
    }

    @IBAction func artistTextFieldDidEnd(_ sender: Any) {
    }
    
    
}
