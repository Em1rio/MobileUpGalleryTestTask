//
//  DetailVideoViewController.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 19.08.2024.
//

import UIKit
import WebKit
import AVKit

final class DetailVideoViewController: UIViewController, WKNavigationDelegate {
    // MARK: - Variables
    private weak var coordinator: DetailVideoCoordinator?
    private var videoUrl: URL
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        return webView
    }()
    // MARK: - Lifecycle
    init(videoUrl: URL, coordinator: DetailVideoCoordinator) {
        self.videoUrl = videoUrl
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        checkInternetAndLoadVideo()
        setupNavigationBar()
        setupWebView()
        loadVideo()
    }
    // MARK: - UI Setup
    private func setupWebView() {
        view.backgroundColor = .white
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: containerView.topAnchor),
            webView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
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
    // MARK: - Actions
    private func checkInternetAndLoadVideo() {
            if NetworkMonitor.shared.isConnected {
                loadVideo()
            } else {
                AlertManager.shared.showNoInternetConnectionAlert(in: self)
            }
        }
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func shareButtonTapped() {
        let activityVC = UIActivityViewController(activityItems: [videoUrl], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    private func loadVideo() {
        let html = """
                <!DOCTYPE html>
                <html>
                <head>
                <style>
                body {
                            margin: 0;
                            padding: 0;
                            overflow: hidden;
                        }
                        .video-container {
                            position: absolute;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                            background: #000;
                        }
                        .video-container iframe {
                            position: absolute;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                            border: 0;
                        }
                </style>
                </head>
                <body>
                <div class="video-container">
                    <iframe src="\(videoUrl.absoluteString)" frameborder="0" allowfullscreen></iframe>
                </div>
                </body>
                </html>
                """
        webView.loadHTMLString(html, baseURL: nil)
    }
    
      // MARK: - WKNavigationDelegate
      func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
          AlertManager.shared.showCustomAlert(in: self, title: "Ошибка!", message: "Что то пошло не так.\n\(error)", buttonTitle: "ОК")
      }
    
}
