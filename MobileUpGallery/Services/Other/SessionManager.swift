//
//  SessionManager.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import Foundation
protocol SessionManagerProtocol {
    var accessToken: String? { get }
    func saveToken(_ token: String, expiresIn: Int?)
    func clearToken()
    func isTokenValid() -> Bool
}

final class SessionManager: SessionManagerProtocol {
    // MARK: - Variables
    private let tokenKey = "accessToken"
    private let expirationDateKey = "tokenExpirationDate"
    private let userDefaults: UserDefaults
    var accessToken: String? {
        return userDefaults.string(forKey: tokenKey)
    }
    // MARK: - Init
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - Actions
    func saveToken(_ token: String, expiresIn: Int?) {
        userDefaults.set(token, forKey: tokenKey)
        if let expiresIn = expiresIn {
            let expirationDate = Date().addingTimeInterval(TimeInterval(expiresIn))
            userDefaults.set(expirationDate, forKey: expirationDateKey)
        }
    }
    
    func clearToken() {
        userDefaults.removeObject(forKey: tokenKey)
        userDefaults.removeObject(forKey: expirationDateKey)
    }
    
    func isTokenValid() -> Bool {
        guard let expirationDate = userDefaults.object(forKey: expirationDateKey) as? Date else {
            return false
        }
        return Date() < expirationDate
    }
}
