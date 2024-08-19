//
//  SceneDelegate.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: Coordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard (scene is UIWindowScene) else { return }
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            NetworkMonitor.shared.startMonitoring()
            let navController = UINavigationController()
            navController.isNavigationBarHidden = true
            let managerLocator = ManagerLocator()
            let sessionManager = managerLocator.getSessionManager()
            appCoordinator = AppCoordinator(window: window,
                                            managerLocator: managerLocator,
                                            navigationController: navController,
                                            sessionManager: sessionManager)
            appCoordinator?.start()
            window.rootViewController = navController
            window.makeKeyAndVisible()
            
        }
    }
}

