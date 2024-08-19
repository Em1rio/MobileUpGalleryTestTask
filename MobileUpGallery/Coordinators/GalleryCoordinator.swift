//
//  GalleryCoordinator.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import Foundation
import UIKit

final class GalleryCoordinator: Coordinator {
    // MARK: - Variables
    private(set) var navigationController: UINavigationController
    private let networkManager: NetworkManagerProtocol
    private let managerLocator: ManagerLocator
    private let sessionManager: SessionManagerProtocol
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var logoutHandler: (() -> Void)?
    // MARK: - Lifecycle
    init(navigationController: UINavigationController,
         networkManager: NetworkManagerProtocol,
         managerLocator: ManagerLocator,
         sessionManager: SessionManagerProtocol) {
        self.navigationController = navigationController
        self.networkManager = networkManager
        self.managerLocator = managerLocator
        self.sessionManager = sessionManager
    }
    // MARK: - Setup
    func start() {
        let galleryViewModel = GalleryViewModel(apiService: managerLocator.getVKAPIService(), networkManager: managerLocator.getNetworkManager(), imageCacheService: managerLocator.getImageCacheService() )
        let galleryViewController = GalleryViewController(galleryViewModel, coordinator: self)
        navigationController.setViewControllers([galleryViewController], animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
        
    }
    func didFinish() {
        if let parentCoordinator = parentCoordinator as? AppCoordinator {
            parentCoordinator.childDidFinish(self)
        } else if let parentCoordinator = parentCoordinator as? LoginCoordinator {
            parentCoordinator.childDidFinish(self)
        }
    }
}

extension GalleryCoordinator {
    func goToDetailPhoto(for photoItem: PhotoItem) {
        let detailPhotoCoordinator = DetailPhotoCoordinator(navigationController: navigationController, networkManager: managerLocator.getNetworkManager(), managerLocator: managerLocator, sessionManager: sessionManager, photoItem: photoItem)
        detailPhotoCoordinator.parentCoordinator = self
        detailPhotoCoordinator.start()
        childCoordinators.append(detailPhotoCoordinator)
    }
    func goToDetailVideo(_ videoUrl: URL, _ title: String) {
        let detailVideoCoordinator = DetailVideoCoordinator(navigationController: navigationController, networkManager: managerLocator.getNetworkManager(), videoUrl: videoUrl, videoTitle: title)
        detailVideoCoordinator.parentCoordinator = self
        detailVideoCoordinator.start()
        childCoordinators.append(detailVideoCoordinator)
    }
    func logOut() {
        sessionManager.clearToken()
        logoutHandler?()
        didFinish()
        
    }
}
