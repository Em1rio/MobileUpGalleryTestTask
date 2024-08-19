//
//  DetailVideoCoordinator.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 19.08.2024.
//

import Foundation
import UIKit

final class DetailVideoCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let networkManager: NetworkManagerProtocol
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    private(set) var videoUrl: URL
    private(set) var videoTitle: String
    
    init(navigationController: UINavigationController,
         networkManager: NetworkManagerProtocol, videoUrl: URL, videoTitle: String) {
        self.navigationController = navigationController
        self.networkManager = networkManager
        self.videoUrl = videoUrl
        self.videoTitle = videoTitle
    }
    
    func start() {
        let detailVideoVC = DetailVideoViewController(videoUrl: videoUrl, coordinator: self)
        detailVideoVC.title = videoTitle
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.pushViewController(detailVideoVC, animated: true)
        navigationController.isNavigationBarHidden = false
    }
}
