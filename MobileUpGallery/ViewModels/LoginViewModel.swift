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
    // MARK: - Init
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
        for param in params {
            let keyValue = param.split(separator: "=")
            if keyValue.count == 2 && keyValue[0] == "access_token" {
                let token = String(keyValue[1])
                saveToken(token)
                print("TOKEN: \(token)")
                onTokenReceived?(token)
                break
            }
        }
    }
    
    private func saveToken(_ token: String) {
        sessionManager.saveToken(token)
    }
}
