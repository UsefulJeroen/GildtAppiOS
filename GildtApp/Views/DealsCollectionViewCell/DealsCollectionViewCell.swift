//
//  DealsCollectionViewCell.swift
//  GildtApp
//
//  Created by Wouter Janson on 18/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import UIKit
import Kingfisher
import StatusAlert

class DealsCollectionViewCell: UICollectionViewCell {
    // view
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var DealImage: UIImageView!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var Usability: UILabel!
    @IBOutlet weak var GreenBar: UIView!
    @IBOutlet weak var Availability: UILabel!
    
    // gesture
    private let slideUpEndDistance:CGFloat = 100.0
    private var slideUpPoint:CGPoint = CGPoint.zero
    private var SlideUpInitPoint:CGPoint = CGPoint.zero
    private var slideUpDelta:CGFloat = 0
    private var slideUpReached = false
    private var initialCenter: CGPoint = CGPoint.zero

    // Data
    var deal: Deal? = nil

    func setUpView() {
        // corner radiusus
        self.layer.cornerRadius = 10
        DealImage.layer.cornerRadius = 15
        GreenBar.layer.cornerRadius = 10
        GreenBar.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        // shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.layer.shadowRadius = 14
        self.layer.shadowOpacity = 0.16
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }

    func loadDealData() {
        self.Title.text = deal?.title
        if let url = deal?.image {
            self.DealImage.kf.setImage(with: URL(string: url))
        }
        self.Description.text = deal?.description
        if deal?.dealType == "usage" {
            self.Usability.text = "Nog \(deal?.dealsLeft ?? 0) keer bruikbaar"
        } else {
            self.Usability.text = "Onbeperkt bruikbaar"
        }
        self.Availability.text = deal?.expireDateHumanized
    }

    private func showStatusAlert(
        withImage image: UIImage?,
        title: String?,
        message: String?) {

        let statusAlert = StatusAlert()
        statusAlert.image = image
        statusAlert.title = title
        statusAlert.message = message
        statusAlert.canBePickedOrDismissed = true
        statusAlert.show(withVerticalPosition: .center)
    }
}

extension DealsCollectionViewCell {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            initialCenter = self.center

            SlideUpInitPoint = touch.location(in: self)
            slideUpPoint = touch.location(in: self)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.location(in: self.superview).y < SlideUpInitPoint.y {
                slideUpPoint = touch.location(in: self.superview)
                slideUpDelta = SlideUpInitPoint.y - slideUpPoint.y

                if slideUpDelta <= self.slideUpEndDistance {
                    let newCenter = CGPoint(x: initialCenter.x, y: initialCenter.y - slideUpDelta)
                    self.center = newCenter
                    slideUpReached = false
                    NotificationCenter.default.post(name: Notification.Name("DealIsSlideUpIdentifier"), object: nil, userInfo: ["ClaimState":false])
                } else if !slideUpReached {
                    slideUpReached = true
                    NotificationCenter.default.post(name: Notification.Name("DealIsSlideUpIdentifier"), object: nil, userInfo: ["ClaimState":true])
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            }
        }
    }

    func reset() {
        self.SlideUpInitPoint = CGPoint.zero
        self.slideUpPoint = CGPoint.zero
        self.slideUpDelta = 0

        NotificationCenter.default.post(name: Notification.Name("DealIsSlideUpIdentifier"), object: nil, userInfo: ["ClaimState":false])

        UIView.animate(withDuration: 0.2, animations: {
            self.center = self.initialCenter
        }, completion: { (complete: Bool) in
            self.initialCenter = self.center
        })
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.slideUpDelta >= self.slideUpEndDistance {
            NotificationCenter.default.post(name: Notification.Name("DealIsClaimedIdentifier"), object: nil, userInfo: ["Deal":deal!])
            showStatusAlert(
                withImage: #imageLiteral(resourceName: "Success icon"),
                title: "Deal ingediend",
                message: "Geniet van je drankje!")
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
        self.reset()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.reset()
    }
}
