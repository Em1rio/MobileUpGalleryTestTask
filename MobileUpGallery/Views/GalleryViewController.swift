//
//  GalleryViewController.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 15.08.2024.
//

import UIKit

final class GalleryViewController: UIViewController {
    // MARK: - Variables
    private(set) var viewModel: GalleryViewModel
    // MARK: - UI Components
    // MARK: - Lifecycle
    init(_ viewModel: GalleryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    // MARK: - UI Setup
    // MARK: - Actions
    
}
