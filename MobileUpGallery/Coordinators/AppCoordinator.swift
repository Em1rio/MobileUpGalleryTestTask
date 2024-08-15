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
}

final class AppCoordinator: Coordinator  {
    // MARK: - Variables
    private let window: UIWindow
    private let managerLocator: ManagerLocator
    private var navigationController: UINavigationController
    private let sessionManager: SessionManagerProtocol
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    // MARK: - Lifecycle
    init(window: UIWindow, managerLocator: ManagerLocator, navigationController: UINavigationController, sessionManager: SessionManagerProtocol) {
        self.window = window
        self.managerLocator = managerLocator
        self.navigationController = navigationController
        self.sessionManager = sessionManager
    }
    // MARK: - Setup
    func start() {
        showMainScreen() 
    }
    // MARK: - Navigation
    private func showMainScreen() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController,
                                              networkManager: managerLocator.getNetworkManager(),
                                              managerLocator: managerLocator,
                                              sessionManager: sessionManager)
        mainCoordinator.parentCoordinator = self
        mainCoordinator.start()
        childCoordinators.append(mainCoordinator)
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
}
