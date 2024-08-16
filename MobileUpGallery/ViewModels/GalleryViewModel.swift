//
//  GalleryViewModel.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import Foundation

final class GalleryViewModel {
    // MARK: - Variables
    private let apiService: VKAPIServiceProtocol
    private let networkManager: NetworkManagerProtocol
    private(set) var photos: [PhotoItem] = []
    // MARK: - Init
    init(apiService: VKAPIServiceProtocol, networkManager: NetworkManagerProtocol) {
        self.apiService = apiService
        self.networkManager = networkManager
    }
    // MARK: - Logic
    func fetchPhotos(completion: @escaping () -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }
        apiService.fetchPhotos(token: token) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos = photos
                completion()
            case .failure(let error):
                print("Failed to fetch photos: \(error)")
            }
        }
    }
    func loadImageData(from urlString: String, completion: @escaping (Data?) -> Void) {
        networkManager.loadImage(from: urlString, completion: completion)
    }
}
