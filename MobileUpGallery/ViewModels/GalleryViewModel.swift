//
//  GalleryViewModel.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import Foundation
protocol GalleryViewModelDelegate: AnyObject {
    func didUpdatePhotos()
    func didUpdateVideos()
}
final class GalleryViewModel {
    // MARK: - Variables
    private let apiService: VKAPIServiceProtocol
    private let networkManager: NetworkManagerProtocol
    private(set) var imageService: ImageCacheServiceProtocol
    private(set) var photos: [PhotoItem] = []
    private(set) var videos: [Video] = []
    private var albums: [Album] = []
    private var currentAlbumIndex = 0
    var isLoadingPhotos = false
    var isAllPhotosLoaded = false
    weak var delegate: GalleryViewModelDelegate?
    // MARK: - Init
    init(apiService: VKAPIServiceProtocol, networkManager: NetworkManagerProtocol, imageCacheService: ImageCacheServiceProtocol ) {
        self.apiService = apiService
        self.networkManager = networkManager
        self.imageService = imageCacheService
    }
    // MARK: - Logic
    func loadAlbums(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }
        apiService.fetchAlbums(token: token) { [weak self] result in
            switch result {
            case .success(let albums):
                self?.albums = albums
                self?.loadPhotos(from: 0, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadPhotos(from index: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard !isLoadingPhotos, index < albums.count else { return }
        
        isLoadingPhotos = true
        let album = albums[index]
        apiService.fetchPhotos(fromAlbum: album.id, token: UserDefaults.standard.string(forKey: "accessToken")!) { [weak self] result in
            self?.isLoadingPhotos = false
            switch result {
            case .success(let photos):
                let newPhotos = photos.filter { newPhoto in
                    !self!.photos.contains(where: { $0.id == newPhoto.id })
                }
                self?.photos.append(contentsOf: newPhotos)
                self?.currentAlbumIndex = index
                self?.isAllPhotosLoaded = index == self?.albums.count ?? 0 - 1
                self?.delegate?.didUpdatePhotos()
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadNextAlbum(completion: @escaping (Result<Void, Error>) -> Void) {
        guard !isAllPhotosLoaded else { return }
        loadPhotos(from: currentAlbumIndex + 1) { [weak self] result in
            switch result {
            case .success():
                DispatchQueue.main.async {
                    self?.delegate?.didUpdatePhotos()
                }
                completion(.success(()))
            case .failure(let error):
                print("Failed to load more photos: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func loadImageData(from urlString: String, completion: @escaping (Data?) -> Void) {
        networkManager.loadImage(from: urlString, completion: completion)
    }
    
    func fetchVideo() {
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }
           apiService.fetchVideos(token: token) { [weak self] result in
               switch result {
               case .success(let videos):
                   self?.videos = videos
                   DispatchQueue.main.async {
                       self?.delegate?.didUpdateVideos()
                   }
               case .failure(let error):
                   print("Failed to fetch videos: \(error)")
               }
           }
    }
    func loadVideoThumbnail(from urlString: String, completion: @escaping (Data?) -> Void) {
        networkManager.loadImage(from: urlString, completion: completion)
    }
    
}
