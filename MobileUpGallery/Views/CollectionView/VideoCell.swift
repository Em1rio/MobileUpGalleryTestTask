//
//  VideoCell.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 17.08.2024.
//

import Foundation
import UIKit

final class VideoCell: UICollectionViewCell {
    // MARK: - Variables
    static let identifier = "VideoCell"
    // MARK: - UI Components
    private let videoPreview: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    private let backgroundLabelView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.backgroundColor = .white.withAlphaComponent(0.5)
        return view
    }()
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0.8
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    // MARK: - Lifecycle
    public func configure(with image: UIImage?, text: String) {
        videoPreview.image = image
        titleLabel.text = text
        setupUI()
        setConstraints()
    }
    // MARK: - UI Setup
    private func setupUI() {
        addSubview(videoPreview)
        videoPreview.addSubview(backgroundLabelView)
        backgroundLabelView.addSubview(titleLabel)
        backgroundLabelView.addSubview(blurEffectView)
        backgroundLabelView.sendSubviewToBack(blurEffectView)
    }
    private func setConstraints() {
        videoPreview.translatesAutoresizingMaskIntoConstraints = false
        backgroundLabelView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            videoPreview.topAnchor.constraint(equalTo: self.topAnchor),
            videoPreview.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            videoPreview.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            videoPreview.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            videoPreview.heightAnchor.constraint(equalToConstant: 210),
            
            backgroundLabelView.trailingAnchor.constraint(equalTo: videoPreview.trailingAnchor, constant: -16),
            backgroundLabelView.bottomAnchor.constraint(equalTo: videoPreview.bottomAnchor, constant: -16),
            backgroundLabelView.leadingAnchor.constraint(greaterThanOrEqualTo: videoPreview.leadingAnchor, constant: 16),
            backgroundLabelView.widthAnchor.constraint(lessThanOrEqualTo: videoPreview.widthAnchor, constant: -32),
            
            blurEffectView.leadingAnchor.constraint(equalTo: backgroundLabelView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: backgroundLabelView.trailingAnchor),
            blurEffectView.topAnchor.constraint(equalTo: backgroundLabelView.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: backgroundLabelView.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: backgroundLabelView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundLabelView.trailingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: backgroundLabelView.topAnchor, constant: 4),
            titleLabel.bottomAnchor.constraint(equalTo: backgroundLabelView.bottomAnchor, constant: -4),
        ])
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        backgroundLabelView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        backgroundLabelView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}
