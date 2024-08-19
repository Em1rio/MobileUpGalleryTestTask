//
//  DetailPhotoCoordinator.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 18.08.2024.
//

import Foundation
import UIKit

final class DetailPhotoCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let networkManager: NetworkManagerProtocol
    private let managerLocator: ManagerLocator
    private let sessionManager: SessionManagerProtocol
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    private(set) var photoItem: PhotoItem
    
    init(navigationController: UINavigationController,
         networkManager: NetworkManagerProtocol,
         managerLocator: ManagerLocator,
         sessionManager: SessionManagerProtocol, photoItem: PhotoItem) {
        self.navigationController = navigationController
        self.networkManager = networkManager
        self.managerLocator = managerLocator
        self.sessionManager = sessionManager
        self.photoItem = photoItem
    }
    
    func start() {
        let detailVM = DetailPhotoViewModel(imageCacheService: managerLocator.getImageCacheService(), photoItem: photoItem)
        let detailVC = DetailPhotoViewController(detailVM, coordinator: self)
        let formattedDate = DateFormatter.shared.formatUnixTimestamp(TimeInterval(photoItem.date))
        detailVC.title = "\(formattedDate)"
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.pushViewController(detailVC, animated: true)
        navigationController.isNavigationBarHidden = false
    }
}
