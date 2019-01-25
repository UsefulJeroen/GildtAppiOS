//
//  BaseViewController.swift
//  GildtApp
//
//  Created by Jeroen Besse on 29/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit

class NavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationButtons()
    }
    
    func setupNavigationButtons() {
        self.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "IconProfile"), style: .plain, target: self, action: #selector(profileClicked))
    }
    
    @objc func profileClicked() {
        let profileVc = R.storyboard.profile.profileViewController()!
        pushViewController(profileVc, animated: true)
    }
}
