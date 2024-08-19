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
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Mobile Up \nGallery"
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 44, weight: .bold)
        return label
    }()
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вход через VK", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        return button
    }()
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
        setupUI()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.didFinish()
    }
    deinit {
        print("Main deinit")
    }
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        setupAppNameLabel()
        setupLoginButton()
        
    }
    private func setupAppNameLabel() {
        view.addSubview(appNameLabel)
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 170),
            appNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            appNameLabel.heightAnchor.constraint(equalToConstant: 106),
        ])
    }
    private func setupLoginButton() {
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            loginButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8 ),
            loginButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -16),
            loginButton.widthAnchor.constraint(equalToConstant: 343),
            loginButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    // MARK: - Actions
    @objc private func loginButtonTapped() {
        coordinator?.showLoginScreen()
    }
}

