//
//  PhotoModel.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import Foundation

// MARK: - PhotoResponse
struct PhotoResponse: Decodable {
    let response: Response
}

// MARK: - Response
struct Response: Decodable {
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

// MARK: - AlbumResponse
struct AlbumResponse: Codable {
    let response: AlbumList
}

// MARK: - AlbumList
struct AlbumList: Codable {
    let count: Int
    let items: [Album]
}

// MARK: - Album
struct Album: Codable {
    let id: Int
    let thumbId: Int
    let ownerId: Int
    let title: String
    let description: String?
    let created: Int?
    let updated: Int?
    let size: Int
    let canUpload: Int?
    let privacyView: [String]?
    let privacyComment: [String]?
    let uploadByAdminsOnly: Int?
    let commentsDisabled: Int?
    let thumbSrc: String?

    enum CodingKeys: String, CodingKey {
        case id
        case thumbId = "thumb_id"
        case ownerId = "owner_id"
        case title
        case description
        case created
        case updated
        case size
        case canUpload = "can_upload"
        case privacyView = "privacy_view"
        case privacyComment = "privacy_comment"
        case uploadByAdminsOnly = "upload_by_admins_only"
        case commentsDisabled = "comments_disabled"
        case thumbSrc = "thumb_src"
    }
}

extension PhotoItem: Equatable {
    static func == (lhs: PhotoItem, rhs: PhotoItem) -> Bool {
        return lhs.id == rhs.id
    }
}
