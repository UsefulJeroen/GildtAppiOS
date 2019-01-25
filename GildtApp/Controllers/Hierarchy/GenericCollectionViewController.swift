//
//  GenericCollectionViewController.swift
//  GildtApp
//
//  Created by Jeroen Besse on 22/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

//basic collectionviewcontroller with functions that all collectionviewcontrollers use;
//show all items
//get all items
//reload all items
//pull to refresh
//autorefresh
//if you want to implement/use this:
//override getCellId & getAPICall in childClass
class GenericCollectionViewController<T: GenericCollectionViewCell<U>, U>: UICollectionViewController where U: Decodable {
    
    var items = [U]()
    
    //timer for autorefresh
    var autorefreshTimer: Timer?
    //seconds between each timer tick for autorefresh
    let autorefreshTimerTickRate = 60.0
    
    func getCellId() -> String {
        print("Error: implement getCellId from GenericCollectionViewController!")
        return "CellId"
    }
    
    func getMainAPICall() -> DataRequest? {
        print("Error: implement getMainAPICall from GeneriCollectionViewController")
        return nil
    }
    
    override func viewDidLoad() {
        //set which collectioncells should be used
        collectionView.register(UINib(nibName: getCellId(), bundle: nil), forCellWithReuseIdentifier: getCellId())
        //setup pull to refresh
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
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
        getItems()
    }
    
    func getItems() {
        if let apiCall = getMainAPICall() {
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
        collectionView.reloadData()
        collectionView.refreshControl?.endRefreshing()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getCellId(), for: indexPath) as! GenericCollectionViewCell<U>
        cell.item = items[indexPath.row]
        return cell
    }
}
