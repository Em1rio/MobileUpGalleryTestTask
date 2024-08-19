//
//  GalleryViewController.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import UIKit

final class GalleryViewController: UIViewController, GalleryViewModelDelegate {
    // MARK: - Variables
    private(set) var viewModel: GalleryViewModel
    private weak var coordinator: GalleryCoordinator?
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "MobileUp Gallery"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = UIColor.black
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выход", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Фото", "Видео"])
        control.selectedSegmentIndex = 0
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13, weight: .medium),
            .foregroundColor: UIColor.black,
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13, weight: .medium),
            .foregroundColor: UIColor.black,
        ]
        control.setTitleTextAttributes(normalAttributes, for: .normal)
        control.setTitleTextAttributes(selectedAttributes, for: .selected)
        control.overrideUserInterfaceStyle = .light
        return control
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    private(set) var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    private(set) var videoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.isHidden = true
        return collectionView
    }()
    
    // MARK: - Lifecycle
    init(_ viewModel: GalleryViewModel, coordinator: GalleryCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.delegate = self
        fetchContent()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        coordinator?.navigationController.setNavigationBarHidden(true, animated: false)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.didFinish()
        
    }
    deinit {
        print("Gallery deinit")
    }
    // MARK: - UI Setup
    private func setupView() {
        view.backgroundColor = UIColor.white
        view.addSubview(titleLabel)
        view.addSubview(logoutButton)
        view.addSubview(segmentedControl)
        view.addSubview(photoCollectionView)
        view.addSubview(videoCollectionView)
        view.addSubview(activityIndicator)
        
        setupLayout()
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifire)
        
        videoCollectionView.delegate = self
        videoCollectionView.dataSource = self
        videoCollectionView.register(VideoCell.self, forCellWithReuseIdentifier: VideoCell.identifier)
        
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
    }
    
    private func setupLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        videoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: logoutButton.leadingAnchor, constant: -16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            segmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            photoCollectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            photoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            videoCollectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            videoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    // MARK: - Actions
    private func fetchContent() {
        activityIndicator.startAnimating()
        if NetworkMonitor.shared.isConnected {
            viewModel.loadAlbums { [weak self] result in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                }
                switch result {
                case .success():
                    DispatchQueue.main.async {
                        self?.photoCollectionView.reloadData()
                        self?.updateCollectionViewLayout(for: self?.segmentedControl.selectedSegmentIndex ?? 0)
                    }
                case .failure(let error):
                    if let strongSelf = self {
                        AlertManager.shared.showDataLoadErrorAlert(in: strongSelf)
                    }
                    print("Failed to load albums: \(error)")
                }
            }
            viewModel.fetchVideo()
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            AlertManager.shared.showNoInternetConnectionAlert(in: self)
        }
        
    }
    @objc private func logoutButtonTapped() {
        coordinator?.logOut()
    }
    @objc private func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            photoCollectionView.isHidden = false
            videoCollectionView.isHidden = true
        case 1:
            photoCollectionView.isHidden = true
            videoCollectionView.isHidden = false
        default:
            break
        }
    }
    func loadImage(for urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = viewModel.imageService.getImage(forKey: urlString) {
            completion(cachedImage)
            return
        }
        viewModel.loadImageData(from: urlString) { [weak self] data in
            if let data = data, let image = UIImage(data: data) {
                self?.viewModel.imageService.imageCache(image, forKey: urlString)
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
    func cacheVideoThumbnail(for urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = viewModel.imageService.getImage(forKey: urlString) {
            completion(cachedImage)
            return
        }
        viewModel.loadVideoThumbnail(from: urlString) { [weak self] data in
            if let data = data, let image = UIImage(data: data) {
                self?.viewModel.imageService.imageCache(image, forKey: urlString)
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
    func didUpdatePhotos() {
        let previousCount = viewModel.photos.count - (viewModel.isLoadingPhotos ? 1 : 0)
        let newCount = viewModel.photos.count
        if newCount > previousCount {
            let indexPaths = (previousCount..<newCount).map { IndexPath(item: $0, section: 0) }
            DispatchQueue.main.async {
                self.photoCollectionView.performBatchUpdates({
                    self.photoCollectionView.insertItems(at: indexPaths)
                }, completion: nil)
                self.activityIndicator.stopAnimating()
            }
        }
        
    }
    func didUpdateVideos() {
        DispatchQueue.main.async {
            self.videoCollectionView.reloadData()
        }
    }
    
    func goToDetail(for photoItem: PhotoItem) {
        coordinator?.goToDetailPhoto(for: photoItem)
    }
    func goToDetail(for videoUrl: URL,with title: String) {
        coordinator?.goToDetailVideo(videoUrl, title)
    }
    
}
