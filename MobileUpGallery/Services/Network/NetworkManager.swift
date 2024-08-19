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
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                let customError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP error \(httpResponse.statusCode)"])
                completion(.failure(customError))
                return
            }
            if let data = data {
                completion(.success(data))
            } else {
                let customError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(customError))
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
