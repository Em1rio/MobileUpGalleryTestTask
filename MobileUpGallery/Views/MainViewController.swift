//
//  MainViewController.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import UIKit

final class MainViewController: UIViewController {
    // MARK: - Variables
    private(set) var viewModel: MainViewModel
    private weak var coordinator: MainCoordinator?
    // MARK: - UI Components
    
    // MARK: - Lifecycle
    init(_ viewModel: MainViewModel, coordinator: MainCoordinator?) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        coordinator?.showLoginScreen()
    }
    // MARK: - UI Setup
    private func setupUI() {
    }
    // MARK: - Actions
}

