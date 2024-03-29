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
        return R.nib.previewImageTableViewCell.name
    }
    
    override func getMainAPICall() -> DataRequest {
        return GildtAPIService.getImagesFromTag(id: tag?.id ?? 0)
    }
    
    var tag: Tag?
    let picker = UIImagePickerController()
    
    //alert + progressView for uploadscreen
    var alert: UIAlertController?
    var progressView: UIProgressView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary;
        picker.allowsEditing = false
        
        navigationItem.title = tag?.title ?? R.string.localizable.photos_Tag()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: R.string.localizable.general_Upload(), style: .plain, target: self, action: #selector(uploadClicked))
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
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// Photo picker stuff
extension TagPhotosViewController {
    private func showAuthorizationAlert() {
        let alertController = UIAlertController(
            title: R.string.localizable.photos_Title(),
            message: R.string.localizable.photos_Permission(),
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: R.string.localizable.general_Settings(), style: .default, handler: { (_) in
            DispatchQueue.main.async {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: R.string.localizable.general_Cancel(), style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func showUploadAlert(image: UIImage) {
        let alertController = UIAlertController(
            title: R.string.localizable.photos_Upload(),
            message: R.string.localizable.photos_Description_Question(),
            preferredStyle: .alert)
        
        alertController.addImage(image)
        
        alertController.addTextField { textField in
            textField.placeholder = R.string.localizable.photos_Description()
        }
        
        alertController.addAction(UIAlertAction(title: R.string.localizable.general_Upload(), style: .default, handler: {
            (alert: UIAlertAction!) in
            if let textField = alertController.textFields?.first {
                self.uploadImage(image: image, description: textField.text!, tag: (self.tag?.id)!)
            }}))
        alertController.addAction(UIAlertAction(title: R.string.localizable.general_Cancel(), style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func uploadImage(image: UIImage, description: String, tag: Int) {
        // Upload modal
        alert = UIAlertController(title: R.string.localizable.photos_Upload(), message: R.string.localizable.photos_Upload_Progress() + " 0%", preferredStyle: .alert)
        let rect = CGRect(x: 10, y: 70, width: 250, height: 0)
        progressView = UIProgressView(frame: rect)
        progressView!.tintColor = UIColor.primaryGildtGreen
        alert!.view.addSubview(progressView!)
        
        self.present(alert!, animated: true, completion: nil)
        
        GildtAPIService.uploadImage(image: image, description: description, tag: tag, callback: photoUploadHandler)
    }
    
    func photoUploadHandler(encodingResult: SessionManager.MultipartFormDataEncodingResult) {
        switch encodingResult {
        case .success(let upload, _, _):
            upload.uploadProgress(closure: { (progress) in
                self.progressView?.setProgress(Float(progress.fractionCompleted), animated: true)
                self.alert?.message = R.string.localizable.photos_Upload_Progress() + " \(NSString(format: "%.1f", progress.fractionCompleted * 100))%"
                if progress.isFinished {
                    self.alert?.dismiss(animated: true, completion: {
                        self.showSuccessMessage()
                    })
                }
                if progress.isCancelled {
                    self.alert?.dismiss(animated: true, completion: {
                        self.showFailureMessage()
                    })
                }
            })
        case .failure(_ ):
            self.showFailureMessage()
        }
    }
    
    private func showSuccessMessage() {
        StatusAlertService().showStatusAlert(
            withImage: #imageLiteral(resourceName: "IconSucces"),
            title: R.string.localizable.photos_Upload_Success_Title(),
            message: R.string.localizable.photos_Upload_Success_Message())
        getItems()
    }
    
    private func showFailureMessage() {
        StatusAlertService().showStatusAlert(
            withImage: #imageLiteral(resourceName: "IconError"),
            title: R.string.localizable.photos_Upload_Fail_Title(),
            message: R.string.localizable.photos_Upload_Fail_Message(),
            error: true)
    }
}

