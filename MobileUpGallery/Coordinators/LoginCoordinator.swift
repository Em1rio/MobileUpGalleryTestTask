//
//  LoginCoordinator.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import Foundation
import UIKit

final class LoginCoordinator: Coordinator {
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
        let loginViewModel = LoginViewModel(apiService: managerLocator.getVKAPIService(), sessionManager: sessionManager)
        let loginViewController = LoginViewController(loginViewModel, coordinator: self)
        navigationController.present(loginViewController, animated: true)
    }
}

// MARK: - Navigation
extension LoginCoordinator {
    func goToGallery() {
        let galleryCoordinator = GalleryCoordinator(navigationController: navigationController, networkManager: managerLocator.getNetworkManager(), managerLocator: managerLocator, sessionManager: sessionManager)
        galleryCoordinator.parentCoordinator = self
        galleryCoordinator.start()
        childCoordinators.append(galleryCoordinator)
    }
}
