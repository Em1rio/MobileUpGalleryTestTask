//
//  SceneDelegate.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard (scene is UIWindowScene) else { return }
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            let vc = ViewController()
            let navController = UINavigationController(rootViewController: vc)
           // navController.isNavigationBarHidden = true
            
            
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }

  

}

