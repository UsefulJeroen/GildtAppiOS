//
//  TagOverviewViewController.swift
//  GildtApp
//
//  Created by Jeroen Besse on 10/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit

class TagOverviewViewController: UICollectionViewController {
    
    let itemsPerRow: CGFloat = 2
    let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    var tags: [Tag] = [Tag(id: 1, title: "taggie", preview_image: "http://vsb2006001.pbworks.com/f/samythehero.jpg", number_of_images: 5)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        getTags()
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TagCollectionViewCell")
    }
    
    func getTags() {
        PhotoAPIService.getAllTags()
            .responseData(completionHandler: { [weak self] (response) in
                guard let jsonData = response.data else { return }
                
                let decoder = JSONDecoder()
                let data = try? decoder.decode([Tag].self, from: jsonData)
                
                DispatchQueue.main.async {
                    if data != nil {
                        self?.reloadData(newData: data!)
                    }
                }
            })
    }
    
    func reloadData(newData: [Tag]) {
        tags = newData
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
        let tag = tags[indexPath.row]
        cell.previewImage.kf.setImage(with: URL(string: tag.preview_image))
        cell.titleTextView.text = tag.title
        cell.amountPhotosTextView.text = String(tag.number_of_images)
        return cell
    }
    
}

extension TagOverviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return sectionInsets.left
    }
}
