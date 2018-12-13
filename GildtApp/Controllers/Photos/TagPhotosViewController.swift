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

class TagPhotosViewController: UITableViewController {
    
    var photos: [Photo] = []
    var tag: Tag = Tag(id: 0, title: "voorbeeldtitel", preview_image: Image(url: "url.com"), number_of_images: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = tag.title
        
        setupTableView()
        getPhotos()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PreviewImageTableViewCell", bundle: nil), forCellReuseIdentifier: "PreviewImageTableViewCell")
    }
    
    func getPhotos() {
        PhotoAPIService.getImagesFromTag(id: tag.id)
            .responseData(completionHandler: { [weak self] (response) in
                guard let jsonData = response.data else { return }
                
                let decoder = JSONDecoder()
                let data = try? decoder.decode([Photo].self, from: jsonData)
                
                DispatchQueue.main.async {
                    if data != nil {
                        self?.reloadNewData(newData: data!)
                    }
                }
            })
    }
    
    func reloadNewData(newData: [Photo]) {
        photos = newData
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        super.tableView(tableView, numberOfRowsInSection: section)
        return photos.count
    }
    
    //set properties for each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreviewImageTableViewCell") as! PreviewImageTableViewCell
        let photo: Photo = photos[indexPath.row]
        
        cell.photo.kf.setImage(with: photo.image.getURL())
        cell.descriptionLabel.text = photo.description
        
        let date = photo.publish_date.toDate(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        cell.publishDateLabel.text = "\(formatter.string(from: date))"
        
        return cell
    }
}
