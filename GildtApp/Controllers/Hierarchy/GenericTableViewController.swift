//
//  GenericTableViewController.swift
//  GildtApp
//
//  Created by Jeroen Besse on 22/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

//basic tableviewcontroller with functions that all tableviewcontrollers use
//if you want to implement this:
//override cellId & getItems in childClass
class GenericTableViewController<T: GenericTableViewCell<U>, U>: UITableViewController where U: Decodable {
    
    var cellId: String = "CellId"
    
    var items = [U]()
    
    func getAPICall() -> DataRequest? { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        getItems()
    }
    
    @objc func refresh() {
        refreshControl?.alpha = 1
        getItems()
    }
    
    func getItems() {
        if let apiCall = getAPICall() {
            apiCall.responseData(completionHandler: { [weak self] (response) in
                guard let jsonData = response.data else { return }
                
                let decoder = JSONDecoder()
                let data = try? decoder.decode([U].self, from: jsonData)
                
                DispatchQueue.main.async {
                    if data != nil {
                        self?.reloadItems(newData: data!)
                    }
                }
            })
        }
    }
    
    func reloadItems(newData: [U]) {
        items = newData
        finishRefreshing()
    }
    
    func finishRefreshing() {
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.refreshControl?.alpha = 0
            self.refreshControl?.endRefreshing()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.refreshControl?.alpha = 1
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! GenericTableViewCell<U>
        cell.item = items[indexPath.row]
        return cell
    }
}