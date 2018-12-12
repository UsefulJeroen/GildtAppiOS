//
//  DeviceInfoHelper.swift
//  GildtApp
//
//  Created by Jeroen Besse on 11/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
struct DeviceInfoHelper {
    
    struct Orientation {
        //indicate current device is in the landsacpe orientation
        static var isLandscape: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation ? UIDevice.current.orientation.isLandscape : UIApplication.shared.statusBarOrientation.isLandscape
            }
        }
        //indicate current device is in the portrait orientation
        static var isPortrait: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation ? UIDevice.current.orientation.isPortrait : UIApplication.shared.statusBarOrientation.isPortrait
            }
        }
    }
}
