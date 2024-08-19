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
        navigationController.pushViewController(galleryViewController, animated: false)
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
    func goToDetail(for photoItem: PhotoItem) {
        let detailCoordinator = DetailCoordinator(navigationController: navigationController, networkManager: managerLocator.getNetworkManager(), managerLocator: managerLocator, sessionManager: sessionManager, photoItem: photoItem)
        detailCoordinator.parentCoordinator = self
        detailCoordinator.start()
        childCoordinators.append(detailCoordinator)
    }
    func logOut() {
        sessionManager.clearToken()
        logoutHandler?()
        didFinish()
        
    }
}
