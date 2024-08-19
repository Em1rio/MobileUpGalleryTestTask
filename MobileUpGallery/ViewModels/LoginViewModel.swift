//
//  LoginViewModel.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import Foundation

final class LoginViewModel {
    // MARK: - Variables
    private let apiService: VKAPIServiceProtocol
    private let sessionManager: SessionManagerProtocol
    var onTokenReceived: ((String) -> Void)?
    // MARK: - Lifecycle
    init(apiService: VKAPIServiceProtocol, sessionManager: SessionManagerProtocol) {
        self.apiService = apiService
        self.sessionManager = sessionManager
    }
    // MARK: - Logic
    func authorize(completion: @escaping (Result<URLRequest, Error>) -> Void) {
        apiService.authorize(completion: completion)
    }
    func handleToken(from url: URL) {
        guard let fragment = url.fragment else { return }
        let params = fragment.split(separator: "&")
        var token: String?
        var expiresIn: Int?
        var userId: String?
        
        for param in params {
            let keyValue = param.split(separator: "=")
            if keyValue.count == 2 {
                let key = String(keyValue[0])
                let value = String(keyValue[1])
                switch key {
                case "access_token":
                    token = value
                case "expires_in":
                    expiresIn = Int(value)
                case "user_id":
                    userId = value
                default:
                    break
                }
            }
        }
        if let token = token {
            saveToken(token, expiresIn: expiresIn)
            onTokenReceived?(token)
        }
        if let expiresIn = expiresIn {
            print("Token expires in \(expiresIn) seconds")
        }
        if let userId = userId {
            print("User ID: \(userId)")
        }
    }

    private func saveToken(_ token: String, expiresIn: Int?) {
        sessionManager.saveToken(token, expiresIn: expiresIn)
    }
}
