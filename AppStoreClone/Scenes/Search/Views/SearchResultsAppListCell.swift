//
//  SearchResultsAppListCell.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 23..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

class SearchResultsAppListCell: BaseTableViewCell {
    
    @IBOutlet weak var collectionImageView: UICollectionView!
    @IBOutlet weak var collectionImageFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var downloadButton: UIButton!
    
    fileprivate var screenshotUrls: [String] = []
    
    var model: SearchResultModel? {
        didSet {
            let artworkUrl60 = model?.artworkUrl60 ?? ""
            let trackCensoredName = model?.trackCensoredName ?? ""
            let sellerName = model?.sellerName ?? ""
            let averageUserRating = model?.averageUserRating ?? 0.0
            let userRatingCount = model?.userRatingCount ?? 0
            let screenshotUrls = model?.screenshotUrls ?? []
            
            self.appIconImageView.setCacheImageURL(URL(string: artworkUrl60))
            self.titleLabel.text = trackCensoredName
            self.subTitleLabel.text = sellerName
            self.ratingCountLabel.text = String.convertCountUnit(userRatingCount)
            self.floatRatingView.rating = averageUserRating
            
            self.downloadButton.setTitle(NSLocalizedString("Download", comment: ""), for: UIControl.State.normal)
            
            self.screenshotUrls = screenshotUrls
            self.collectionImageView.reloadData()
        }
    }
    
    override func initialization() {
        super.initialization()
        
        collectionImageView.delegate = self
        collectionImageView.dataSource = self
        collectionImageView.allowsSelection = false
        collectionImageView.isUserInteractionEnabled = false
        collectionImageView.backgroundColor = UIColor.white
        
        collectionImageFlowLayout.scrollDirection = .horizontal
        collectionImageFlowLayout.minimumLineSpacing = 0
        collectionImageFlowLayout.minimumInteritemSpacing = 0
        collectionImageFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        floatRatingView.backgroundColor = UIColor.clear
        floatRatingView.delegate = self
        floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView.type = .floatRatings
        floatRatingView.editable = false
        
        appIconImageView.clipsToBounds = true
        appIconImageView.layer.cornerRadius = 10.0
        
        downloadButton.layer.cornerRadius = 10.0
    }
    
}

extension SearchResultsAppListCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshotUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultsAppListImageCollectionCell", for: indexPath) as? SearchResultsAppListImageCollectionCell {
            cell.imageUrl = screenshotUrls[safe: indexPath.item]
            return cell
        }
        return UICollectionViewCell()
    }
    
}

extension SearchResultsAppListCell: UICollectionViewDelegate {
    
    //func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //}
    
}

extension SearchResultsAppListCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var t = CGFloat(screenshotUrls.count)
        if t > 3.0 {
            t = 3.0
        }
        let w = collectionView.frame.size.width / t
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

extension SearchResultsAppListCell: FloatRatingViewDelegate {
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        DDLogDebug("didUpdate \(String(format: "%.2f", self.floatRatingView.rating))")
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        DDLogDebug("isUpdating \(String(format: "%.2f", self.floatRatingView.rating))")
    }
    
}
