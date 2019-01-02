//
//  StatusAlertService.swift
//  GildtApp
//
//  Created by Wouter Janson on 31/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit
import StatusAlert

class StatusAlertService {
    func showStatusAlert(
        withImage image: UIImage?,
        title: String?,
        message: String?,
        error: Bool = false) {
        
        let statusAlert = StatusAlert()
        statusAlert.image = image
        statusAlert.title = title
        statusAlert.message = message
        statusAlert.canBePickedOrDismissed = false
        if error {
            statusAlert.appearance.tintColor = UIColor.errorRed
        }
        statusAlert.show(withVerticalPosition: .center)
    }
}
