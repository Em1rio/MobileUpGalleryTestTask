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
    private let navigationController: UINavigationController
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
        let mainViewModel = MainViewModel(apiService: managerLocator.getVKAPIService(),
                                          networkManager: managerLocator.getNetworkManager())
        let mainViewController = MainViewController(mainViewModel, coordinator: self)
        navigationController.setViewControllers([mainViewController], animated: true)
        
    }
    func didFinish() {
        guard let parentCoordinator = parentCoordinator as? AppCoordinator else { return }
        parentCoordinator.childDidFinish(self)
        
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
        loginCoordinator.logoutHandler = logoutHandler
        loginCoordinator.start()
        childCoordinators.append(loginCoordinator)
    }
    
}
