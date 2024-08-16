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
    private let navigationController: UINavigationController
    private let networkManager: NetworkManagerProtocol
    private let managerLocator: ManagerLocator
    private let sessionManager: SessionManagerProtocol
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
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
        let galleryViewModel = GalleryViewModel(apiService: managerLocator.getVKAPIService(), networkManager: managerLocator.getNetworkManager())
        let galleryViewController = GalleryViewController(galleryViewModel, coordinator: self)
        navigationController.pushViewController(galleryViewController, animated: false)
    }
}
