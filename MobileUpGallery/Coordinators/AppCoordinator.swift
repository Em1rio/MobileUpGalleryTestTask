//
//  AppCoordinator.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import Foundation
import UIKit
protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    func start()
    func childDidFinish(_ child: Coordinator?)
    var logoutHandler: (() -> Void)? { get set }
}

final class AppCoordinator: Coordinator  {
    // MARK: - Variables
    private let window: UIWindow
    private let managerLocator: ManagerLocator
    private let navigationController: UINavigationController
    private let sessionManager: SessionManagerProtocol
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var logoutHandler: (() -> Void)?
    // MARK: - Lifecycle
    init(window: UIWindow, managerLocator: ManagerLocator, navigationController: UINavigationController, sessionManager: SessionManagerProtocol) {
        self.window = window
        self.managerLocator = managerLocator
        self.navigationController = navigationController
        self.sessionManager = sessionManager
        self.logoutHandler = { [weak self] in
            self?.performLogout()
        }
    }
    // MARK: - Setup
    func start() {
        if sessionManager.isTokenValid() {
            showGalleryScreen()
        } else {
            showMainScreen()
        }
    }
    private func performLogout() {
        sessionManager.clearToken()
        self.start()
    }
    // MARK: - Navigation
    private func showMainScreen() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController,
                                              networkManager: managerLocator.getNetworkManager(),
                                              managerLocator: managerLocator,
                                              sessionManager: sessionManager)
        mainCoordinator.parentCoordinator = self
        mainCoordinator.logoutHandler = logoutHandler
        mainCoordinator.start()
        childCoordinators.append(mainCoordinator)
    }
    private func showGalleryScreen() {
        let galleryCoordinator = GalleryCoordinator(navigationController: navigationController,
                                                    networkManager: managerLocator.getNetworkManager(),
                                                    managerLocator: managerLocator,
                                                    sessionManager: sessionManager)
        galleryCoordinator.parentCoordinator = self
        galleryCoordinator.logoutHandler = logoutHandler
        galleryCoordinator.start()
        childCoordinators.append(galleryCoordinator)
    }
    
    
}
// MARK: - Default values and methods for protocol
extension Coordinator {
    var parentCoordinator: Coordinator? { nil }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in
                childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    var logoutHandler: (() -> Void)? {
        get { return nil }
        set { }
    }
}
