//
//  Models.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import Foundation

// MARK: - PhotoResponse
struct PhotoResponse: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let count: Int
    let items: [PhotoItem]
    let nextFrom: String

    enum CodingKeys: String, CodingKey {
        case count
        case items
        case nextFrom = "next_from"
    }
}

// MARK: - PhotoItem
struct PhotoItem: Codable {
    let date: Int
    let id: Int
    let origPhoto: PhotoSize
    let postId: Int?
    let sizes: [PhotoSize]
    let text: String
    let userId: Int
    let webViewToken: String

    enum CodingKeys: String, CodingKey {
        case date
        case id
        case origPhoto = "orig_photo"
        case postId = "post_id"
        case sizes
        case text
        case userId = "user_id"
        case webViewToken = "web_view_token"
    }
}

// MARK: - PhotoSize
struct PhotoSize: Codable {
    let height: Int
    let type: String
    let url: String
    let width: Int
}
