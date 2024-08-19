//
//  APIService.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import Foundation
import VK_ios_sdk

protocol VKAPIServiceProtocol {
    func authorize(completion: @escaping (Result<URLRequest, Error>) -> Void)
    func fetchAlbums(token: String, completion: @escaping (Result<[Album], Error>) -> Void)
    func fetchPhotos(fromAlbum albumId: Int, token: String, completion: @escaping (Result<[PhotoItem], Error>) -> Void)
    func fetchVideos(token: String, completion: @escaping (Result<[Video], Error>) -> Void)
}

final class VKAPIService: VKAPIServiceProtocol {
    // MARK: - Variables
    private let networkManager: NetworkManagerProtocol
    private let sessionManager: SessionManagerProtocol
    // MARK: - Init
    init(networkManager: NetworkManagerProtocol, sessionManager: SessionManagerProtocol) {
        self.networkManager = networkManager
        self.sessionManager = sessionManager
    }
    
    func authorize(completion: @escaping (Result<URLRequest, Error>) -> Void) {
        let clientId = "52143011"
        let redirectURI = "https://oauth.vk.com/blank.html"
        let authURL = "https://oauth.vk.com/authorize?client_id=\(clientId)&display=mobile&redirect_uri=\(redirectURI)&scope=20&response_type=token&v=5.131"
        guard let url = URL(string: authURL) else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }
        let request = URLRequest(url: url)
        completion(.success(request))
    }
    
    func fetchAlbums(token: String, completion: @escaping (Result<[Album], Error>) -> Void) {
        let urlString = "https://api.vk.com/method/photos.getAlbums?owner_id=-128666765&access_token=\(token)&v=5.131"
        guard let url = URL(string: urlString) else { return }
        
        networkManager.performRequest(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let albumResponse = try JSONDecoder().decode(AlbumResponse.self, from: data)
                    completion(.success(albumResponse.response.items))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchPhotos(fromAlbum albumId: Int, token: String, completion: @escaping (Result<[PhotoItem], Error>) -> Void) {
        let urlString = "https://api.vk.com/method/photos.get?owner_id=-128666765&album_id=\(albumId)&access_token=\(token)&v=5.131"
        guard let url = URL(string: urlString) else { return }
        
        networkManager.performRequest(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let photoResponse = try JSONDecoder().decode(PhotoResponse.self, from: data)
                    completion(.success(photoResponse.response.items))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchVideos(token: String, completion: @escaping (Result<[Video], Error>) -> Void) {
        let groupId = "-128666765"
        let urlString = "https://api.vk.com/method/video.get?owner_id=\(groupId)&access_token=\(token)&v=5.131"
        
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }
        
        networkManager.performRequest(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let error = json["error"] as? [String: Any],
                           let errorMessage = error["error_msg"] as? String {
                            let errorCode = error["error_code"] as? Int ?? 0
                            let customError = NSError(domain: "", code: errorCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                            completion(.failure(customError))
                            return
                        }
                        if let response = json["response"] as? [String: Any],
                           let items = response["items"] as? [[String: Any]] {
                            
                            let videos = items.compactMap { item -> Video? in
                                guard let title = item["title"] as? String,
                                      let player = item["player"] as? String,
                                      let imageArray = item["image"] as? [[String: Any]],
                                      let firstImage = imageArray.last,
                                      let thumbnailUrl = firstImage["url"] as? String else {
                                    return nil
                                }
                                return Video(title: title, videoUrl: player, thumbnailUrl: thumbnailUrl)
                            }
                            completion(.success(videos))
                        } else {
                            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse response"])
                            completion(.failure(error))
                        }
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
