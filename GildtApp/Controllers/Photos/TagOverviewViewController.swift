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

class TagOverviewViewController: GenericCollectionViewController<TagCollectionViewCell, Tag>, UICollectionViewDelegateFlowLayout {
    
    override func getCellId() -> String {
        return "TagCollectionViewCell"
    }
    
    override func getMainAPICall() -> DataRequest {
        return PhotoAPIService.getAllTags()
    }
    
    let itemsPerRow: CGFloat = 2
    let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Foto's"
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Photo", bundle: nil)
        let tagPhotosVc = storyboard.instantiateViewController(withIdentifier: "TagPhotosViewController") as! TagPhotosViewController
        let tag = items[indexPath.row]
        tagPhotosVc.tag = tag
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

//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat
//    {
//        return sectionInsets.left
//    }

//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
}
