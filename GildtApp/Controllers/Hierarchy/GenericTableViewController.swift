//
//  GenericTableViewController.swift
//  GildtApp
//
//  Created by Jeroen Besse on 22/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit

class GenericTableViewController<T: GenericTableViewCell<U>, U>: UITableViewController {
    
    func getCellId() -> String {
        return "cellId"
    }
    
    var items = [U]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: getCellId(), bundle: nil), forCellReuseIdentifier: getCellId())
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        getItems()
    }
    
    @objc func refresh() {
        refreshControl?.alpha = 1
        getItems()
    }
    
    func getItems() {}
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: getCellId(), for: indexPath) as! GenericTableViewCell<U>
        cell.item = items[indexPath.row]
        return cell
    }
}
