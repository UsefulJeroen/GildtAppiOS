//
//  LocalStorageService.swift
//  GildtApp
//
//  Created by Jeroen Besse on 14/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

//class to set data in the localstorage of device
//will be used to save authtoken in keychain
//and can be extended to support other data / settings
final class LocalStorageService {
    private static let authTokenKey: String = "changeToSecureRandomKey"
    
    static func setAuthToken(authToken: String) {
        KeychainWrapper.standard.set(authToken, forKey: authTokenKey)
    }
    
    //hardcoded authToken, will be fixed when we have a login/register page
    static func getAuthToken() -> String? {
        //return KeychainWrapper.standard.string(forKey: authTokenKey)
        return "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1NDI0NTAzMTAsInN1YiI6M30.Hsjr-ngSDhwRXUSKSFwlcE_A7KlPhZGCuQY26lKmnZE"
    }
    
    //hardcoded authToken, will be fixed when we have a login/register page
    static func isAuthTokenSet() -> Bool {
        //return KeychainWrapper.standard.string(forKey: authTokenKey) != nil
        return true
    }
    
    static func removeAuthToken() {
        KeychainWrapper.standard.removeObject(forKey: authTokenKey)
    }
}
