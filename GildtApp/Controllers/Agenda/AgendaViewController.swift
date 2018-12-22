//
//  AgendaViewController.swift
//  GildtApp
//
//  Created by Jeroen Besse on 29/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class AgendaViewController: GenericTableViewController<AgendaTableViewCell, Event>, UIViewControllerPreviewingDelegate {
    
    override func getCellId() -> String {
        return "AgendaTableViewCell"
    }
    
    override func getMainAPICall() -> DataRequest {
        return AgendaAPIService.getAgendaItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Agenda"
        
        registerForPreviewing(with: self, sourceView: tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.AttendanceNotificationHandler(notification:)), name: NSNotification.Name(rawValue: "AttendanceIdentifier"), object: nil)
    }
    
    @objc private func AttendanceNotificationHandler(notification: Notification) {
        let event = notification.userInfo!["Event"] as! Event
        if let i = items.firstIndex(where: {$0.id == event.id}) {
            items[i] = event
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected \(indexPath.row)")
        self.navigationController?.pushViewController(detailViewController(for: indexPath.row), animated: true)
    }
    
    func detailViewController(for index: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: "Agenda", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EventViewController") as! EventViewController
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.event = items[index]
        return vc
    }
    
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
