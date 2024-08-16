//
//  SessionManager.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import Foundation
protocol SessionManagerProtocol {
    var accessToken: String? { get }
    func saveToken(_ token: String)
    func clearToken()
    func isTokenValid() -> Bool
}

class SessionManager: SessionManagerProtocol {
    // MARK: - Variables
    private let tokenKey = "accessToken"
    private let userDefaults: UserDefaults
    // MARK: - Init
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    var accessToken: String? {
        return userDefaults.string(forKey: tokenKey)
    }
    
    func saveToken(_ token: String) {
        userDefaults.set(token, forKey: tokenKey)
    }
    
    func clearToken() {
        userDefaults.removeObject(forKey: tokenKey)
    }
    
    func isTokenValid() -> Bool {
        return accessToken != nil
    }
}
