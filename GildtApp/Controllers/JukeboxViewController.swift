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
    
    var songRequests: [SongRequest] = []
    
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
        //register custom nib for songrequest-row
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        super.tableView(tableView, numberOfRowsInSection: section)
        return 99
    }
    
    
}
