//
//  VideoModel.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 19.08.2024.
//

import Foundation

struct VideoResponse: Codable {
    let response: VideoResponseItems
}

struct VideoResponseItems: Codable {
    let items: [VideoItem]
}

struct VideoItem: Codable {
    let id: Int
    let owner_id: Int
    let title: String
    let duration: Int
    let image: [VideoImage]
}

struct VideoImage: Codable {
    let url: String
    let width: Int
    let height: Int
}

struct Video {
    let title: String
    let videoUrl: String
    let thumbnailUrl: String?

}
