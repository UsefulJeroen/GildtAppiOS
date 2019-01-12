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
        return GildtAPIService.getImagesFromTag(id: tag?.id ?? 0)
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
    private func showAuthorizationAlert() {
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
    
    private func showUploadAlert(image: UIImage) {
        let alertController = UIAlertController(
            title: "Foto upload",
            message: "Wat valt er op deze foto te zien?",
            preferredStyle: .alert)
        
        alertController.addImage(image)
        
        alertController.addTextField { textField in
            textField.placeholder = "Beschrijving"
        }
        
        alertController.addAction(UIAlertAction(title: "Upload", style: .default, handler: {
            (alert: UIAlertAction!) in
            if let textField = alertController.textFields?.first {
                self.uploadImage(image: image, description: textField.text!, tag: (self.tag?.id)!)
            }}))
        alertController.addAction(UIAlertAction(title: "Annuleer", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func uploadImage(image: UIImage, description: String, tag: Int) {
        let baseURL = "https://gildt.inholland-informatica.nl/api/v1"
        let authToken = LocalStorageService.getAuthToken()!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(authToken)"]
        let imageData = image.jpegData(compressionQuality: 0.6)
        
        // Upload modal
        let alert = UIAlertController(title: "Foto uploaden", message: "Voortgang: 0%", preferredStyle: .alert)
        let rect = CGRect(x: 10, y: 70, width: 250, height: 0)
        let progressView = UIProgressView(frame: rect)
        progressView.tintColor = UIColor.primaryGildtGreen
        alert.view.addSubview(progressView)
        
        self.present(alert, animated: true, completion: nil)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData!, withName: "image", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            multipartFormData.append(description.data(using: .utf8)!, withName: "description")
            multipartFormData.append(String(tag).data(using: .utf8)!, withName: "tags")
        }, to: URL(string: "\(baseURL)/image")!,
           method: .post,
           headers: headers) { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    progressView.setProgress(Float(progress.fractionCompleted), animated: true)
                    alert.message = "Voortgang: \(NSString(format: "%.1f", progress.fractionCompleted * 100))%"
                    if progress.isFinished {
                        alert.dismiss(animated: true, completion: {
                            self.showSuccessMessage()
                        })
                    }
                    if progress.isCancelled {
                        alert.dismiss(animated: true, completion: {
                            self.showFailureMessage()
                        })
                    }
                })
            case .failure(_ ):
                self.showFailureMessage()
            }
        }
    }
    
    private func showSuccessMessage() {
        StatusAlertService().showStatusAlert(
            withImage: #imageLiteral(resourceName: "IconSucces"),
            title: "Foto geupload",
            message: "Bedankt voor je foto!")
    }
    
    private func showFailureMessage() {
        StatusAlertService().showStatusAlert(
            withImage: #imageLiteral(resourceName: "IconError"),
            title: "Foto niet geupload",
            message: "er is iets fout gegaan tijdens het uploaden!",
            error: true)
    }
}
