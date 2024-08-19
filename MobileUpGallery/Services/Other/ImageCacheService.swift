//
//  ImageCacheService.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import Foundation
import UIKit

protocol ImageCacheServiceProtocol {
    func imageCache(_ image: UIImage, forKey key: String)
    func getImage(forKey key: String) -> UIImage?
    func clearCache()
}

final class ImageCacheService: ImageCacheServiceProtocol {
    private let cache = NSCache<NSString, UIImage>()
    
    func imageCache(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}
