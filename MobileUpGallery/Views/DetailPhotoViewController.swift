//
//  DetailPhotoViewController.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import UIKit

final class DetailPhotoViewController: UIViewController {
    // MARK: - Variables
    private(set) var viewModel: DetailPhotoViewModel
    private weak var coordinator: DetailPhotoCoordinator?
    // MARK: - UI Components
    private let imageView = UIImageView()
    // MARK: - Lifecycle
    init(_ viewModel: DetailPhotoViewModel, coordinator: DetailPhotoCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        displayCachedImage()
    }
    deinit {
        print("Detail deinit")
    }
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        setupNavigationBar()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor) // Square aspect ratio
        ])
    }
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(image: UIImage(named: "arrowBack"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        shareButton.tintColor = .black
        navigationItem.rightBarButtonItem = shareButton
    }
    private func showAlert(title: String, message: String) {
        AlertManager.shared.showAutoDismissAlert(in: self, title: title, message: message)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func shareButtonTapped() {
        guard let image = imageView.image else { return }
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityVC.completionWithItemsHandler = { [weak self] activityType, completed, returnedItems, error in
                if completed {
                    self?.showAlert(title: "Успех!", message: "Фотография сохранена.")
                } else if let error = error {
                    self?.showAlert(title: "Ошибка!", message: error.localizedDescription)
                }
            }
        present(activityVC, animated: true, completion: nil)
    }
    private func displayCachedImage() {
        if let cachedImage = getCachedImage() {
            imageView.image = cachedImage
        } else {
            print("Image not found in cache")
        }
    }
    private func getCachedImage() -> UIImage? {
        if let bestSize = viewModel.photoItem.sizes.first(where: { $0.type == "x" || $0.type == "y" })?.url {
            return viewModel.imageService.getImage(forKey: bestSize)
        } else {
            return UIImage(systemName: "photo")
        }
    }
    
}
