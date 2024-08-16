//
//  LoginViewController.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import UIKit
import WebKit

final class LoginViewController: UIViewController, WKNavigationDelegate {
    // MARK: - Variables
    private(set) var viewModel: LoginViewModel
    private weak var coordinator: LoginCoordinator?
    // MARK: - UI Components
    private let webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    // MARK: - Lifecycle
    init(_ viewModel: LoginViewModel, coordinator: LoginCoordinator?) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.onTokenReceived = { [weak self] token in
            self?.coordinator?.goToGallery()
            self?.coordinator?.parentCoordinator?.childDidFinish(self?.coordinator)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        authorize()
    }
    // MARK: - UI Setup
    private func setup() {
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    // MARK: - Actions
    @objc private func authorize() {
        viewModel.authorize { [weak self] result in
            switch result {
            case .success(let request):
                self?.webView.load(request)
            case .failure(let error):
                print("Error during authorization: \(error.localizedDescription)")
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.absoluteString.contains("access_token") {
            viewModel.handleToken(from: url)
            dismiss(animated: true, completion: nil)
        }
        decisionHandler(.allow)
    }
}
