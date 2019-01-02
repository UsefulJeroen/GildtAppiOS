//
//  TagPhotosViewController.swift
//  GildtApp
//
//  Created by Jeroen Besse on 13/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import Alamofire
import SKPhotoBrowser

class TagPhotosViewController: GenericTableViewController<PreviewImageTableViewCell, Photo> {
    
    override func getCellId() -> String {
        return "PreviewImageTableViewCell"
    }
    
    override func getMainAPICall() -> DataRequest {
        return PhotoAPIService.getImagesFromTag(id: tag?.id ?? 0)
    }
    
    var tag: Tag?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = tag?.title ?? "Tag"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //convert Photo's to SKPhoto's to use in SKPhotoBrowser
        var images = [SKPhoto]()
        for item in items {
            let photo = SKPhoto.photoWithImageURL(item.image.getURLString())
            photo.shouldCachePhotoURLImage = true
            photo.caption = item.description
            images.append(photo)
        }
        //present skPhotoBrowser
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(indexPath.row)
        present(browser, animated: true, completion: {})
    }
}
