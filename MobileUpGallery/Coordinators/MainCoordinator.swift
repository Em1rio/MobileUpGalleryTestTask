//
//  MainCoordinator.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import Foundation
import UIKit

final class MainCoordinator: Coordinator {
    // MARK: - Variables
    var navigationController: UINavigationController
    private var networkManager: NetworkManagerProtocol
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
        let mainViewModel = MainViewModel(apiService: managerLocator.getVKAPIService(),
                                          networkManager: managerLocator.getNetworkManager())
        let mainViewController = MainViewController(mainViewModel, coordinator: self)
        navigationController.setViewControllers([mainViewController], animated: true)
        
    }
}
// MARK: - Navigation
extension MainCoordinator {
    func showLoginScreen() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController,
                                                networkManager: managerLocator.getNetworkManager(),
                                                managerLocator: managerLocator,
                                                sessionManager: sessionManager)
        loginCoordinator.parentCoordinator = self
        loginCoordinator.start()
        childCoordinators.append(loginCoordinator)
    }
}
