//
//  JukeboxViewController.swift
//  GildtApp
//
//  Created by Jeroen Besse on 14/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit

class JukeboxViewController: UITableViewController {
    
    var image: UIImage?
    
    private let tableHeaderViewheight: CGFloat = 500.0
    private let tableHeaderViewCutaway: CGFloat = 40.0
    
    //var headerView: DetailHeaderView!
    //var headerMaskLayer: CASHapeLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Jukebox"
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
}
