//
//  SearchDetailPreviewCell.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 23..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

class SearchDetailPreviewCell: BaseTableViewCell {
    
    @IBOutlet weak var collectionImageView: UICollectionView!
    @IBOutlet weak var collectionImageFlowLayout: UICollectionViewFlowLayout!
    
    fileprivate var screenshotUrls: [String] = []
    
    var model: SearchResultModel? {
        didSet {
            let screenshotUrls = model?.screenshotUrls ?? []
            
            self.screenshotUrls = screenshotUrls
            self.collectionImageView.reloadData()
        }
    }
    
    override func initialization() {
        super.initialization()
        
        collectionImageView.delegate = self
        collectionImageView.dataSource = self
        collectionImageView.backgroundColor = UIColor.white
        
        collectionImageFlowLayout.scrollDirection = .horizontal
        collectionImageFlowLayout.minimumLineSpacing = 0
        collectionImageFlowLayout.minimumInteritemSpacing = 0
        collectionImageFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

}

extension SearchDetailPreviewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshotUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchDetailPreviewImageCollectionCell", for: indexPath) as? SearchDetailPreviewImageCollectionCell {
            cell.imageUrl = screenshotUrls[safe: indexPath.item]
            return cell
        }
        return UICollectionViewCell()
    }
    
}

extension SearchDetailPreviewCell: UICollectionViewDelegate {
    
    //func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //}
    
}

extension SearchDetailPreviewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.frame.size.width * 0.6
        let h = collectionView.frame.size.height
        return CGSize(width: w - 5.0, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
}
