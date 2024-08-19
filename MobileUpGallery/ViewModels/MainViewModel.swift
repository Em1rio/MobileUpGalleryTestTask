//
//  MainViewModel.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import Foundation

final class MainViewModel {
    // MARK: - Variables
    private let apiService: VKAPIServiceProtocol
    private let networkManager: NetworkManagerProtocol
    // MARK: - Lifecycle
    init(apiService: VKAPIServiceProtocol, networkManager: NetworkManagerProtocol) {
        self.apiService = apiService
        self.networkManager = networkManager
    }
}
