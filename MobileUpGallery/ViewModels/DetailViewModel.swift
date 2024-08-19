//
//  DetailViewModel.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import Foundation

final class DetailViewModel {
    // MARK: - Variables
    private(set) var imageService: ImageCacheServiceProtocol
    private(set) var photoItem: PhotoItem
    // MARK: - Init
    init(imageCacheService: ImageCacheServiceProtocol, photoItem: PhotoItem) {
        self.imageService = imageCacheService
        self.photoItem = photoItem
    }
    // MARK: - Logic
    
}
