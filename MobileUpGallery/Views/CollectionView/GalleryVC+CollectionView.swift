//
//  GalleryVC+CollectionView.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 16.08.2024.
//

import Foundation
import UIKit

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    private func configurePhotoMode() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
        let numberOfColumns: CGFloat = 2
        let itemWidth = (collectionView.bounds.width - (numberOfColumns + 1) * layout.minimumInteritemSpacing) / numberOfColumns
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.reloadData()
    }
    
    private func configureVideoMode() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
        layout.itemSize = CGSize(width: collectionView.bounds.width - 2, height: collectionView.bounds.width * 0.56)
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.reloadData()
    }
    
    func updateCollectionViewLayout(for mode: Int) {
        if mode == 0 {
            configurePhotoMode()
        } else {
            configureVideoMode()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return (collectionViewLayout as! UICollectionViewFlowLayout).itemSize
    }
}

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        let photoItem = viewModel.photos[indexPath.item]
        if let bestSize = photoItem.sizes.first(where: { $0.type == "x" || $0.type == "y" })?.url {
            viewModel.loadImageData(from: bestSize) { data in
                guard let data = data else {
                    DispatchQueue.main.async {
                        cell.configure(with: nil)
                    }
                    return
                }
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    cell.configure(with: image)
                }
            }
        }
        return cell
    }
}
