//
//  TagPhotosViewController.swift
//  GildtApp
//
//  Created by Jeroen Besse on 10/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit

class TagPhotosViewControllerOld: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    var myCollectionView: UICollectionView!
    //let itemsPerRow: CGFloat = 2
    //let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    var photos: [UIImage] = [UIImage(named: "defaultImage")!, UIImage(named: "defaultImage")!, UIImage(named: "defaultImage")!, UIImage(named: "defaultImage")!, UIImage(named: "defaultImage")!, UIImage(named: "defaultImage")!, UIImage(named: "defaultImage")!, UIImage(named: "defaultImage")!, UIImage(named: "defaultImage")!, UIImage(named: "defaultImage")!, UIImage(named: "defaultImage")!]
    var tag: Tag = Tag(id: 0, title: "voorbeeldtitel", preview_image: Image(url: "url.com"), number_of_images: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = tag.title
        setupCollectionView()
        getPhotos()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewLayout()
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.register(PhotoItemCell.self, forCellWithReuseIdentifier: "PhotoCell")
        myCollectionView.backgroundColor = UIColor.white
        self.view.addSubview(myCollectionView)
        //make sure the page also works in horizontal mode
        //myCollectionView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.RawValue(UInt8(UIView.AutoresizingMask.flexibleWidth.rawValue) | UInt8(UIView.AutoresizingMask.flexibleHeight.rawValue)))
    }
    
    func getPhotos() {
        PhotoAPIService.getImagesFromTag(id: tag.id ?? 0)
            .responseData(completionHandler: { [weak self] (response) in
                guard let jsonData = response.data else { return }
                
                let decoder = JSONDecoder()
                let data = try? decoder.decode([Photo].self, from: jsonData)
                
                DispatchQueue.main.async {
                    if data != nil {
                        self?.reloadData(newData: data!)
                    }
                }
            })
    }
    
    func reloadData(newData: [Photo]) {
        //photos.append(
        myCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoItemCell
        let photo = photos[indexPath.row]
        cell.img.image = photo
        //cell.img.kf.setImage(with: photo.image.getURL())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ImagePreviewViewController()
        //todo; FIX THIS
        //vc.imgArray = self.photos
        vc.passedContentOffset = indexPath
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        if DeviceInfoHelper.Orientation.isPortrait {
            let length: Int = Int(width / 4 - 1)
            return CGSize(width: length, height: length)
        }
        else {
            let length: Int = Int(width / 6 - 1)
            return CGSize(width: length, height: length)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class PhotoItemCell: UICollectionViewCell {
    
    var img = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        self.addSubview(img)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        img.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
