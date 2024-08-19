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
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
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
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.didFinish()
        
    }
    deinit {
        print("login deinit")
    }
    // MARK: - UI Setup
    private func setup() {
        webView.navigationDelegate = self
        view.addSubview(webView)
        view.addSubview(activityIndicator)
        webView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    // MARK: - Actions
    @objc private func authorize() {
        activityIndicator.startAnimating()
        if NetworkMonitor.shared.isConnected {
            viewModel.authorize { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let request):
                        self?.webView.load(request)
                    case .failure(let error):
                        if let strongSelf = self {
                            AlertManager.shared.showDataLoadErrorAlert(in: strongSelf)
                        }
                        print("Error during authorization: \(error.localizedDescription)")
                    }
                    self?.activityIndicator.stopAnimating()
                }
            }
        }else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            AlertManager.shared.showNoInternetConnectionAlert(in: self)
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
