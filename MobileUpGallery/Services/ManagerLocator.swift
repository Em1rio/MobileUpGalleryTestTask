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
    private let alertService: AlertServiceProtocol
    private let shareService: ShareServiceProtocol
    private let imageCacheService: ImageCacheServiceProtocol
    private let videoCacheService: VideoCacheServiceProtocol
    private let vkAPIService: VKAPIServiceProtocol
    
    // MARK: - Initialization
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        
        self.sessionManager = SessionManager(userDefaults: userDefaults)
        self.networkManager = NetworkManager(sessionManager: sessionManager)
        self.alertService = AlertService()
        self.shareService = ShareService()
        self.imageCacheService = ImageCacheService()
        self.videoCacheService = VideoCacheService()

        let accessToken = sessionManager.accessToken ?? ""
        self.vkAPIService = VKAPIService(networkManager: networkManager, sessionManager: sessionManager)
    }
    
    // MARK: - Accessors for Services and Managers
    
    func getNetworkManager() -> NetworkManagerProtocol { return networkManager }
    func getSessionManager() -> SessionManagerProtocol { return sessionManager }
    func getAlertService() -> AlertServiceProtocol { return alertService }
    func getShareService() -> ShareServiceProtocol { return shareService }
    func getImageCacheService() -> ImageCacheServiceProtocol { return imageCacheService }
    func getVideoCacheService() -> VideoCacheServiceProtocol { return videoCacheService }
    func getVKAPIService() -> VKAPIServiceProtocol { return vkAPIService }
}
