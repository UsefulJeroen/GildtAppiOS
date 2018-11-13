//
//  LocalStorageService.swift
//  GildtApp
//
//  Created by Jeroen Besse on 14/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

final class LocalStorageService {
    private static let authTokenKey: String = "changeToSecureRandomKey"
    
    static func setAuthToken(authToken: String) {
        KeychainWrapper.standard.set(authToken, forKey: authTokenKey)
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
}
