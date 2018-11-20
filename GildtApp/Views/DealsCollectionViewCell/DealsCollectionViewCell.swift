//
//  DealsCollectionViewCell.swift
//  GildtApp
//
//  Created by Wouter Janson on 18/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import UIKit

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
    private var initialCenter: CGPoint = CGPoint.zero

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
}

extension DealsCollectionViewCell {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            initialCenter = self.center

            SlideUpInitPoint = touch.location(in: self)
            slideUpPoint = touch.location(in: self)
            print("Start")
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.location(in: self.superview).y < SlideUpInitPoint.y {
                slideUpPoint = touch.location(in: self.superview)
                slideUpDelta = SlideUpInitPoint.y - slideUpPoint.y
                print("Updated: Delta \(self.slideUpDelta)")

                if slideUpDelta <= self.slideUpEndDistance {
                    let newCenter = CGPoint(x: initialCenter.x, y: initialCenter.y - slideUpDelta)
                    self.center = newCenter
                }
            }
        }
    }

    func reset() {
        self.SlideUpInitPoint = CGPoint.zero
        self.slideUpPoint = CGPoint.zero
        self.slideUpDelta = 0

        self.center = initialCenter
        initialCenter = self.center
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Ended")
        if self.slideUpDelta >= self.slideUpEndDistance {
            print("CLAIMED")
        } else {
            print("NOT CLAIMED")
        }
        self.reset()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Cancelled")
        if self.slideUpDelta >= self.slideUpEndDistance {
            print("CLAIMED")
        } else {
            print("NOT CLAIMED")
        }
        self.reset()
    }
}
