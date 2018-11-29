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
import StatusAlert

class DealsViewController: UIViewController {
    
    let cellPercentWidth: CGFloat = 0.7
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!

    var deals: [Deal] = []

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var LetGoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Deals"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(getDeals))
        view.backgroundColor = UIColor.appBackground
        
        setUpCollectionView()
        getDeals()

        // Set up DealIsSlideUp && DealIsClaimend Notification Observer
        NotificationCenter.default.addObserver(self, selector: #selector(self.DealIsSlideUpNotificationHandler(notification:)), name: NSNotification.Name(rawValue: "DealIsSlideUpIdentifier"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DealIsClaimedNotificationHandler(notification:)), name: NSNotification.Name(rawValue: "DealIsClaimedIdentifier"), object: nil)
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
        collectionView.reloadData()
    }

    private func showStatusAlert(
        withImage image: UIImage?,
        title: String?,
        message: String?) {

        let statusAlert = StatusAlert()
        statusAlert.image = image
        statusAlert.title = title
        statusAlert.message = message
        statusAlert.canBePickedOrDismissed = true
        statusAlert.show(withVerticalPosition: .center)
    }

    @objc private func DealIsSlideUpNotificationHandler(notification: Notification) {
        let showLabel = notification.userInfo!["ClaimState"] as! Bool
        if showLabel {
            LetGoLabel.isHidden = false
        } else {
            LetGoLabel.isHidden = true
        }
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
                        self?.dealUnsuccessfullyRedeemed(message: (response.error?.localizedDescription)!)
                    }
                }
            })
    }

    func dealSuccessfullyRedeemed(updatedDeal: Deal) {
        // TODO: Still need to check for when coupon is used the last time
        if let i = deals.firstIndex(where: {$0.id == updatedDeal.id}) {
            deals[i] = updatedDeal
            collectionView.reloadData()
        }

        showStatusAlert(
            withImage: #imageLiteral(resourceName: "Success icon"),
            title: "Deal ingediend",
            message: "Geniet van je drankje!")
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    func dealUnsuccessfullyRedeemed(message: String) {
        showStatusAlert(
            withImage: #imageLiteral(resourceName: "Success icon"), // Needs other image
            title: "Whoops!",
            message: message)
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}

extension DealsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected Cell #\(indexPath.row)")
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
        cell.deal = deals[indexPath.row]
        cell.loadDealData()
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("Current centered index: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("Current centered index: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
    }
}
