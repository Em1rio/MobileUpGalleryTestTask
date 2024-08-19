//
//  GalleryVC+CollectionView.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 16.08.2024.
//

import Foundation
import UIKit

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == photoCollectionView {
            return 1
        } else if collectionView == videoCollectionView {
            return 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == photoCollectionView {
            return 1
        } else if collectionView == videoCollectionView {
            return 10
        }
        return 0
    }
    
    private func configureLayout(for mode: Int) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
        
        switch mode {
        case 0:
            layout.minimumInteritemSpacing = 1
            let numberOfColumns: CGFloat = 2
            let itemWidth = (photoCollectionView.bounds.width - (numberOfColumns + 1) * layout.minimumInteritemSpacing) / numberOfColumns
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
            photoCollectionView.setCollectionViewLayout(layout, animated: true)
            photoCollectionView.reloadData()
            
        case 1:
            layout.minimumInteritemSpacing = 1
            layout.minimumLineSpacing = 10
            let itemWidth = videoCollectionView.bounds.width
            let itemHeight: CGFloat = 210
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            videoCollectionView.setCollectionViewLayout(layout, animated: true)
            videoCollectionView.reloadData()
            
        default:
            break
        }
    }
    
    func updateCollectionViewLayout(for mode: Int) {
        configureLayout(for: mode)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == photoCollectionView {
            let width = (collectionView.bounds.width - 3) / 2
            return CGSize(width: width, height: width)
        } else if collectionView == videoCollectionView {
            let width = collectionView.bounds.width
            let height: CGFloat = 210
            return CGSize(width: width, height: height)
        }
        return CGSize.zero
    }
    
}

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == photoCollectionView {
            return viewModel.photos.count
        } else if collectionView == videoCollectionView {
            return viewModel.videos.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == photoCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifire, for: indexPath) as! PhotoCell
            let photoItem = viewModel.photos[indexPath.item]
            if let bestSize = photoItem.sizes.first(where: { $0.type == "x" || $0.type == "y" })?.url {
                loadImage(for: bestSize) { image in
                    DispatchQueue.main.async {
                        cell.configure(with: image)
                    }
                }
            }
            return cell
        } else if collectionView == videoCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.identifier, for: indexPath) as! VideoCell
            let video = viewModel.videos[indexPath.item]
            cacheVideoThumbnail(for: video.thumbnailUrl ?? "") { image in
                DispatchQueue.main.async {
                    cell.configure(with: image, text: video.title)
                }
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
}

extension GalleryViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        if contentOffsetY > contentHeight - scrollViewHeight * 2 {
            if !viewModel.isLoadingPhotos && !viewModel.isAllPhotosLoaded {
                viewModel.loadNextAlbum { [weak self] result in
                    switch result {
                    case .success():
                        DispatchQueue.main.async {
                            self?.photoCollectionView.reloadData()
                        }
                    case .failure(let error):
                        print("Failed to load more photos: \(error)")
                    }
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mode = segmentedControl.selectedSegmentIndex
        if mode == 0 {
            let photoItem = viewModel.photos[indexPath.item]
            goToDetail(for: photoItem)
        } else {
            let video = viewModel.videos[indexPath.item]
            let videoUrlString = video.videoUrl
            if let videoUrl = URL(string: video.videoUrl) {
                goToDetail(for: videoUrl, with: video.title)
            } else {
                print("Invalid URL string: \(videoUrlString)")
            }
        }
    }
}
