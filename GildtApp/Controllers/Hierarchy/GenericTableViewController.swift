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

//basic tableviewcontroller with functions that all tableviewcontrollers use;
//show all items
//get all items
//reload all items
//pull to refresh
//autorefresh
//if you want to implement/use this:
//override getCellId & getAPICall in childClass
class GenericTableViewController<T: GenericTableViewCell<U>, U>: UITableViewController where U: Decodable {
    
    var items = [U]()
    
    //timer for autorefresh
    var autorefreshTimer: Timer?
    //seconds between each timer tick for autorefresh
    let autorefreshTimerTickRate = 60.0
    
    func getCellId() -> String {
        print("Error: implement getCellId from GenericTableViewController!")
        return "CellId"
    }
    
    func getMainAPICall() -> DataRequest? {
        print("Error: implement getMainAPICall from GenericTableViewController!")
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set which tableviewcells should be used
        tableView.register(UINib(nibName: getCellId(), bundle: nil), forCellReuseIdentifier: getCellId())
        //setup pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //check for new info when user open's page
        getItems()
        startAutoRefreshTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopAutoRefreshTimer()
    }
    
    func startAutoRefreshTimer() {
        autorefreshTimer = Timer.scheduledTimer(timeInterval: autorefreshTimerTickRate, target: self, selector: #selector(onTimerTick), userInfo: nil, repeats: true)
        autorefreshTimer?.tolerance = 0.30
    }
    
    func stopAutoRefreshTimer() {
        autorefreshTimer?.invalidate()
    }
    
    @objc func onTimerTick(timer: Timer) {
        getItems()
    }
    
    @objc func refresh() {
        refreshControl?.alpha = 1
        getItems()
    }
    
    func getItems() {
        if let apiCall = getMainAPICall() {
            //weak self to avoid memory leak
            apiCall.responseData(completionHandler: { [weak self] (response) in
                guard let jsonData = response.data else { return }
                
                let decoder = JSONDecoder()
                let data = try? decoder.decode([U].self, from: jsonData)
                
                DispatchQueue.main.async {
                    if let data = data {
                        self?.reloadItems(newData: data)
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
        //extra code to fix pull to refresh weirdness
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
        let cell = tableView.dequeueReusableCell(withIdentifier: getCellId(), for: indexPath) as! GenericTableViewCell<U>
        cell.item = items[indexPath.row]
        return cell
    }
}
