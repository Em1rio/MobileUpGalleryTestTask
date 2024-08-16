//
//  APIService.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import Foundation
protocol VKAPIServiceProtocol {
    func authorize(completion: @escaping (Result<URLRequest, Error>) -> Void)
    func fetchPhotos(token: String, completion: @escaping (Result<[PhotoItem], Error>) -> Void)
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
        let authURL = "https://oauth.vk.com/authorize?client_id=\(clientId)&display=mobile&redirect_uri=\(redirectURI)&scope=photos,video&response_type=token&v=5.131"
        guard let url = URL(string: authURL) else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }
        let request = URLRequest(url: url)
        completion(.success(request))
    }
    func fetchPhotos(token: String, completion: @escaping (Result<[PhotoItem], Error>) -> Void) {
        let groupId = "128666765"
        let urlString = "https://api.vk.com/method/photos.get?owner_id=-\(groupId)&album_id=wall&access_token=\(token)&v=5.131"
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

}
