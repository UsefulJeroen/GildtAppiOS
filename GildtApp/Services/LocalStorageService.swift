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
    private static let usernameKey: String = "GildtProfilename"
    private static let onboardingKey: String = "GildtOnboardingKey"
    
    static func setAuthToken(authToken: String) {
        KeychainWrapper.standard.set(authToken, forKey: authTokenKey)
    }
    
    static func setUsername(username: String) {
        UserDefaults.standard.set(username, forKey: usernameKey)
    }
    
    static func getUsername() -> String? {
        return UserDefaults.standard.string(forKey: usernameKey)
    }
    
    static func getAuthToken() -> String? {
        return KeychainWrapper.standard.string(forKey: authTokenKey)
    }
    
    static func isAuthTokenSet() -> Bool {
        return KeychainWrapper.standard.string(forKey: authTokenKey) != nil
    }
    
    static func removeAuthToken() {
        KeychainWrapper.standard.removeObject(forKey: authTokenKey)
    }
    
    static func setOnboardingState(state: Bool) {
        UserDefaults.standard.set(state, forKey: onboardingKey)
    }
    
    static func getOnboardingState() -> Bool {
        return UserDefaults.standard.bool(forKey: onboardingKey)
    }
}
