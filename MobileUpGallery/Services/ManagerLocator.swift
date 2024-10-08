//
//  ManagerLocator.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import Foundation

final class ManagerLocator {
    // MARK: - Properties
    private let userDefaults: UserDefaults
    private let networkManager: NetworkManagerProtocol
    private let sessionManager: SessionManagerProtocol
    private let imageCacheService: ImageCacheServiceProtocol
    private let vkAPIService: VKAPIServiceProtocol
    
    // MARK: - Initialization
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.sessionManager = SessionManager(userDefaults: userDefaults)
        self.networkManager = NetworkManager(sessionManager: sessionManager)
        self.imageCacheService = ImageCacheService()
        self.vkAPIService = VKAPIService(networkManager: networkManager, sessionManager: sessionManager)
    }
    
    // MARK: - Accessors for Services and Managers
    func getNetworkManager() -> NetworkManagerProtocol { return networkManager }
    func getSessionManager() -> SessionManagerProtocol { return sessionManager }
    func getImageCacheService() -> ImageCacheServiceProtocol { return imageCacheService }
    func getVKAPIService() -> VKAPIServiceProtocol { return vkAPIService }
}
