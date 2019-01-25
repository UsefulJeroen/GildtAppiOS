//
//  TagOverviewViewController.swift
//  GildtApp
//
//  Created by Jeroen Besse on 10/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class TagOverviewViewController: GenericCollectionViewController<TagCollectionViewCell, Tag>, UICollectionViewDelegateFlowLayout, UIViewControllerPreviewingDelegate {
    
    override func getCellId() -> String {
        return "TagCollectionViewCell"
    }
    
    override func getMainAPICall() -> DataRequest {
        return GildtAPIService.getAllTags()
    }
    
    let itemsPerRow: CGFloat = 2
    let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = R.string.localizable.photos_Title()
        
        registerForPreviewing(with: self, sourceView: collectionView)
    }
    
    func createDetailVc(indexPath: IndexPath) -> TagPhotosViewController {
        let tagPhotosVc = R.storyboard.photo.tagPhotosViewController()!
        let tag = items[indexPath.row]
        tagPhotosVc.tag = tag
        return tagPhotosVc
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tagPhotosVc = createDetailVc(indexPath: indexPath)
        self.navigationController?.pushViewController(tagPhotosVc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //MARK: 3D-touch previewing
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = collectionView?.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView?.cellForItem(at: indexPath) else { return nil }
        
        let tagPhotosVc = createDetailVc(indexPath: indexPath)
        
        previewingContext.sourceRect = cell.frame
        
        return tagPhotosVc
    }
        
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}
