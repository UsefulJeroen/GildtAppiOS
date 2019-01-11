//
//  UIAlertController.swift
//  GildtApp
//
//  Created by Wouter Janson on 11/01/2019.
//  Copyright © 2019 Gildt. All rights reserved.
//

import UIKit

extension UIAlertController {
    func addImage(_ image: UIImage) {
        let maxSize = CGSize(width: 245, height: 125)
        
        var ratio : CGFloat!
        if (image.size.width >= image.size.height) {
            ratio = maxSize.width / image.size.width
        } else {
            ratio = maxSize.height / image.size.height
        }
        
        let scaledSize = CGSize(
            width: image.size.width * ratio,
            height: image.size.height * ratio)
        
        var scaledImage = resizeImage(source: image, resizeTo: scaledSize)
        if image.size.height >= image.size.width {
            let offset = (maxSize.width - scaledImage.size.width) / 2
            scaledImage = scaledImage.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -offset, bottom: 0, right: 0))
        }
        
        let imageAction = UIAlertAction(title: String(), style: .default, handler: nil)
        imageAction.isEnabled = false
        imageAction.setValue(scaledImage.withRenderingMode(.alwaysOriginal), forKey: "image")
        self.addAction(imageAction)
    }
    
    private func resizeImage(source:UIImage, resizeTo: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(resizeTo)
        source.draw(in: CGRect(x:0, y:0, width:resizeTo.width, height:resizeTo.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
