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

class TagPhotosViewController: GenericTableViewController<PreviewImageTableViewCell, Photo> {
    
    override func getCellId() -> String {
        return "PreviewImageTableViewCell"
    }
    
    override func getMainAPICall() -> DataRequest {
        return PhotoAPIService.getImagesFromTag(id: tag.id)
    }
    
    var tag: Tag = Tag(id: 0, title: "voorbeeldtitel", preview_image: Image(url: "url.com"), number_of_images: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = tag.title
    }
}
