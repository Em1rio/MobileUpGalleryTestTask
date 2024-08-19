//
//  DetailCoordinator.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 18.08.2024.
//

import Foundation
import UIKit

final class DetailCoordinator: Coordinator {
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
        let detailVM = DetailViewModel(imageCacheService: managerLocator.getImageCacheService(), photoItem: photoItem)
        let detailVC = DetailViewController(detailVM, coordinator: self)
        let formattedDate = DateFormatter.shared.formatUnixTimestamp(TimeInterval(photoItem.date))
        detailVC.title = "\(formattedDate)"
        navigationController.pushViewController(detailVC, animated: true)
        navigationController.isNavigationBarHidden = false
    }
}
