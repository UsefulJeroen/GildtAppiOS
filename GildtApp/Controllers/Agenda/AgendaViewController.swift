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
        
        registerForPreviewing(with: self, sourceView: tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.AttendanceNotificationHandler(notification:)), name: NSNotification.Name(rawValue: "AttendanceIdentifier"), object: nil)
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
    
    @objc private func AttendanceNotificationHandler(notification: Notification) {
        let event = notification.userInfo!["Event"] as! Event
        if let i = agenda.firstIndex(where: {$0.id == event.id}) {
            agenda[i] = event
        }
        tableView.reloadData()
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
        self.navigationController?.pushViewController(detailViewController(for: indexPath.row), animated: true)
    }
    
    func detailViewController(for index: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: "Agenda", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EventViewController") as! EventViewController
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.event = agenda[index]
        return vc
    }
}

extension AgendaViewController : UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView.indexPathForRow(at: location) {
            previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
            return detailViewController(for: indexPath.row)
        }
        
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}
