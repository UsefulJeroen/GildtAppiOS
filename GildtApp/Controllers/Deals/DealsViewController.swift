//
//  DealsViewController.swift
//  GildtApp
//
//  Created by Wouter Janson on 18/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit
import CenteredCollectionView

class DealsViewController: UIViewController {
    
    let cellPercentWidth: CGFloat = 0.7
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!

    var deals: [Deal] = []

    let statusAlertService = StatusAlertService()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var LetGoLabel: UILabel!
    @IBOutlet weak var NoDealsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Deals"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(getDeals))
        view.backgroundColor = UIColor.appBackground
        
        setUpCollectionView()
        getDeals()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        // Set up DealSlideUpIsActive, DealIsSlideUp & DealIsClaimend Notification Observer
        NotificationCenter.default.addObserver(self, selector: #selector(self.SlideUpIsActiveIdentifierNotificationHandler(notification:)), name: NSNotification.Name(rawValue: "SlideUpIsActiveIdentifier"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DealIsSlideUpNotificationHandler(notification:)), name: NSNotification.Name(rawValue: "DealIsSlideUpIdentifier"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DealIsClaimedNotificationHandler(notification:)), name: NSNotification.Name(rawValue: "DealIsClaimedIdentifier"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    private func setUpCollectionView() {
        centeredCollectionViewFlowLayout = collectionView.collectionViewLayout as? CenteredCollectionViewFlowLayout

        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast

        collectionView.delegate = self
        collectionView.dataSource = self
        
        centeredCollectionViewFlowLayout.itemSize = CGSize(
            width: view.bounds.width * cellPercentWidth,
            height: view.bounds.height * cellPercentWidth * cellPercentWidth
        )
        centeredCollectionViewFlowLayout.minimumLineSpacing = 20
    }

    @objc private func getDeals() {
        DealsAPIService.getDeals()
            .responseData(completionHandler: { [weak self] (response) in
                guard let jsonData = response.data else { return }

                let decoder = JSONDecoder()
                let data = try? decoder.decode([Deal].self, from: jsonData)

                DispatchQueue.main.async {
                    if data != nil {
                        self?.reloadDeals(newData: data!)
                    }
                }
            })
    }

    func reloadDeals(newData: [Deal]) {
        deals = newData
        deals = deals.filter({$0.dealsLeft != 0})
        NoDealsLabel.isHidden = deals.count != 0
        collectionView.reloadData()
    }

    @objc private func SlideUpIsActiveIdentifierNotificationHandler(notification: Notification) {
        collectionView.isScrollEnabled = false
    }
    
    @objc private func DealIsSlideUpNotificationHandler(notification: Notification) {
        collectionView.isScrollEnabled = true
        let showLabel = notification.userInfo!["ClaimState"] as! Bool
        LetGoLabel.isHidden = !showLabel
    }

    @objc private func DealIsClaimedNotificationHandler(notification: Notification) {
        let deal = notification.userInfo!["Deal"] as! Deal
        redeemDeal(deal: deal)
    }
    
    func redeemDeal(deal: Deal) {
        DealsAPIService.redeemDeal(deal: deal)
            .responseData(completionHandler: { [weak self] (response) in
                guard let jsonData = response.data else { return }

                let decoder = JSONDecoder()
                let data = try? decoder.decode(Deal.self, from: jsonData)

                DispatchQueue.main.async {
                    if data != nil {
                        self?.dealSuccessfullyRedeemed(updatedDeal: data!)
                    } else {
                        self?.dealUnsuccessfullyRedeemed(message: "Er is iets mis gegaan tijdens het indienen...")
                    }
                }
            })
    }

    func dealSuccessfullyRedeemed(updatedDeal: Deal) {
        if let i = deals.firstIndex(where: {$0.id == updatedDeal.id}) {
            if updatedDeal.dealsLeft == 0 {
                deals.remove(at: i)
            } else {
                deals[i] = updatedDeal
            }
            collectionView.reloadData()
        }
        statusAlertService.showStatusAlert(
            withImage: #imageLiteral(resourceName: "IconSucces"),
            title: "Deal ingediend",
            message: "Geniet van je drankje!")
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    func dealUnsuccessfullyRedeemed(message: String) {
        statusAlertService.showStatusAlert(
            withImage: #imageLiteral(resourceName: "IconError"),
            title: "Whoops!",
            message: message,
            error: true)
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}

extension DealsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let currentCenteredPage = centeredCollectionViewFlowLayout.currentCenteredPage,
            currentCenteredPage != indexPath.row {
            centeredCollectionViewFlowLayout.scrollToPage(index: indexPath.row, animated: true)
        }
    }
}

extension DealsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: "CollectionViewCell"), for: indexPath) as! DealsCollectionViewCell
        cell.setUpView()
        cell.item = deals[indexPath.row]
        return cell
    }
}
