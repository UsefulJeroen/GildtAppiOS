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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Deals"
        view.backgroundColor = UIColor.appBackground
        
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
    
}

extension DealsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected Cell #\(indexPath.row)")
    }
}

extension DealsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: "CollectionViewCell"), for: indexPath) as! DealsCollectionViewCell
        cell.setUpView()
        cell.Description.text = "Cell #\(indexPath.row)"
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("Current centered index: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("Current centered index: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
    }
}
