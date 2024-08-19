//
//  PhotoCell.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 16.08.2024.
//

import Foundation
import UIKit

final class PhotoCell: UICollectionViewCell {
    static let identifire = "PhotoCell"
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    public func configure(with image: UIImage?) {
        imageView.image = image 
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
