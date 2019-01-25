//
//  DealsCollectionViewCell.swift
//  GildtApp
//
//  Created by Wouter Janson on 18/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import UIKit
import Kingfisher

class DealsCollectionViewCell: GenericCollectionViewCell<Deal> {
    // view
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var DealImage: UIImageView!
    @IBOutlet weak var Description: UILabelTopAlign!
    @IBOutlet weak var Usability: UILabel!
    @IBOutlet weak var GreenBar: UIView!
    @IBOutlet weak var Availability: UILabel!
    
    // gesture
    private let slideUpEndDistance:CGFloat = 100.0
    private var slideUpPoint:CGPoint = CGPoint.zero
    private var SlideUpInitPoint:CGPoint = CGPoint.zero
    private var slideUpDelta:CGFloat = 0
    private var slideUpIsActive = false
    private var slideUpReached = false
    private var initialCenter: CGPoint = CGPoint.zero

    // Data
    override var item: Deal! {
        didSet {
            loadDealData()
        }
    }

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
        self.Title.text = item?.title
        if let url = item?.image {
            self.DealImage.kf.setImage(with: URL(string: url))
        }
        self.Description.text = item?.description
        if item?.dealType == "usage" {
            self.Usability.text = R.string.localizable.deals_Usage_Still() +
            "\(item?.dealsLeft ?? 0) " +
            R.string.localizable.deals_Times_Usable()
        } else {
            self.Usability.text = R.string.localizable.deals_Usable_Unlimited()
        }
        self.Availability.text = item?.expireDateHumanized
    }
    
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
                    // logic to Disable scrollview after sliding up
                    if !slideUpIsActive {
                        if slideUpDelta >= 5 {
                            slideUpIsActive = true
                            NotificationCenter.default.post(name: Notification.Name("SlideUpIsActiveIdentifier"), object: nil, userInfo: nil)
                        }
                    }
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
        self.slideUpIsActive = false
        
        NotificationCenter.default.post(name: Notification.Name("DealIsSlideUpIdentifier"), object: nil, userInfo: ["ClaimState":false])
        
        UIView.animate(withDuration: 0.2, animations: {
            self.center = self.initialCenter
        }, completion: { (complete: Bool) in
            self.initialCenter = self.center
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.slideUpDelta >= self.slideUpEndDistance {
            NotificationCenter.default.post(name: Notification.Name("DealIsClaimedIdentifier"), object: nil, userInfo: ["Deal":item!])
        }
        self.reset()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.reset()
    }
}
