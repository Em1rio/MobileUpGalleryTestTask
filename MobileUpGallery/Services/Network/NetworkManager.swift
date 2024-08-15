//
//  NetworkManager.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import Foundation
protocol NetworkManagerProtocol {
    func performRequest(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    // MARK: - Variables
    private let sessionManager: SessionManagerProtocol
    
    // MARK: - Init
    init(sessionManager: SessionManagerProtocol) {
        self.sessionManager = sessionManager
    }
    
    func performRequest(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
        if let token = sessionManager.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                completion(.success(data))
            }
        }
        task.resume()
    }
}
