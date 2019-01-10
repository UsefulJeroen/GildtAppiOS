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
import Photos

class TagPhotosViewController: GenericTableViewController<PreviewImageTableViewCell, Photo>, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    override func getCellId() -> String {
        return "PreviewImageTableViewCell"
    }
    
    override func getMainAPICall() -> DataRequest {
        return PhotoAPIService.getImagesFromTag(id: tag?.id ?? 0)
    }
    
    var tag: Tag?
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary;
        picker.allowsEditing = false
        
        navigationItem.title = tag?.title ?? "Tag"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Upload", style: .plain, target: self, action: #selector(uploadClicked))
    }
    
    @objc func uploadClicked() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized) {
            self.present(picker, animated: true, completion: nil)
        }
            
        else if (status == PHAuthorizationStatus.denied) {
            showAuthorizationAlert()
        }
            
        else if (status == PHAuthorizationStatus.notDetermined) {
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    self.present(self.picker, animated: true, completion: nil)
                } else {
                    self.showAuthorizationAlert()
                }
            })
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        
        showUploadAlert(image: chosenImage)
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

// Photo picker stuff
extension TagPhotosViewController {
    func showAuthorizationAlert() {
        let alertController = UIAlertController(
            title: "Foto's",
            message: "'t Gildt heeft toegang nodig tot je foto's wanneer je een foto wilt uploaden.",
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Instellingen", style: .default, handler: { (_) in
            DispatchQueue.main.async {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "Annuleer", style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showUploadAlert(image: UIImage) {
        let alertController = UIImageAlertController(
            title: "Foto upload",
            message: "Wat valt er op deze foto te zien?",
            preferredStyle: .alert)
        
        alertController.setTitleImage(image)
        
        alertController.addTextField { textField in
            textField.placeholder = "Beschrijving"
        }
        
        alertController.addAction(UIAlertAction(title: "Upload", style: .default, handler: {
            (alert: UIAlertAction!) in
            if let textField = alertController.textFields?.first {
                // DO UPLOAD
            }}))
        alertController.addAction(UIAlertAction(title: "Annuleer", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}
