//
//  NetworkManager.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import Foundation
protocol NetworkManagerProtocol {
    func performRequest(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
    func loadImage(from urlString: String, completion: @escaping (Data?) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    // MARK: - Variables
    private let sessionManager: SessionManagerProtocol
    
    // MARK: - Init
    init(sessionManager: SessionManagerProtocol) {
        self.sessionManager = sessionManager
    }
    //MARK: - Calls
    func performRequest(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
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
    
    func loadImage(from urlString: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            completion(data)
        }
        task.resume()
    }
}
