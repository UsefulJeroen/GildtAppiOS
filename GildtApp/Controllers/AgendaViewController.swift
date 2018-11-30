//
//  AgendaViewController.swift
//  GildtApp
//
//  Created by Jeroen Besse on 29/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit

class AgendaViewController: UITableViewController {
    
    var agenda: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Agenda"
        setupTableView()
        getAgendaItems()
        setupRefreshControl()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AgendaTableViewCell", bundle: nil), forCellReuseIdentifier: "AgendaTableViewCell")
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh() {
        refreshControl?.alpha = 1
        getAgendaItems()
    }
    
    func getAgendaItems() {
        AgendaAPIService.getAgendaItems()
            .responseData(completionHandler: { [weak self] (response) in
                guard let jsonData = response.data else { return }
                
                let decoder = JSONDecoder()
                let data = try? decoder.decode([Event].self, from: jsonData)
                
                DispatchQueue.main.async {
                    if data != nil {
                        self?.reloadAgenda(newData: data!)
                    }
                }
            })
    }
    
    func reloadAgenda(newData: [Event]) {
        agenda = newData
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
        super.tableView(tableView, numberOfRowsInSection: section)
        return agenda.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "AgendaTableViewCell") as! AgendaTableViewCell
        cell.event = agenda[indexPath.row]
        cell.loadEventData()

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected \(indexPath.row)")
    }
}
