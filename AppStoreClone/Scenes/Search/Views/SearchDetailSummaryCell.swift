//
//  SearchDetailSummaryCell.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 23..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

class SearchDetailSummaryCell: BaseTableViewCell {

    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageDescLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    var model: SearchResultModel? {
        didSet {
            let artworkUrl100 = model?.artworkUrl100 ?? ""
            let trackCensoredName = model?.trackCensoredName ?? ""
            let sellerName = model?.sellerName ?? ""
            let trackContentRating = model?.trackContentRating ?? ""
            let averageUserRating = model?.averageUserRating ?? 0.0
            let userRatingCount = model?.userRatingCount ?? 0
            
            self.appIconImageView.setCacheImageURL(URL(string: artworkUrl100))
            self.titleLabel.text = trackCensoredName
            self.subTitleLabel.text = sellerName
            self.ageLabel.text = trackContentRating
            self.ratingLabel.text = "\(averageUserRating)"
            self.ratingCountLabel.text = "\(String.convertCountUnit(userRatingCount))\(NSLocalizedString("UserRatingCountDesc", comment: ""))"
            self.floatRatingView.rating = averageUserRating
            
            self.ageDescLabel.text = NSLocalizedString("Age", comment: "")
            self.downloadButton.setTitle(NSLocalizedString("Download", comment: ""), for: UIControl.State.normal)
        }
    }
    
    override func initialization() {
        super.initialization()
        
        floatRatingView.backgroundColor = UIColor.clear
        floatRatingView.delegate = self
        floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView.type = .floatRatings
        floatRatingView.editable = false
        
        appIconImageView.clipsToBounds = true
        appIconImageView.layer.cornerRadius = 10.0
        
        downloadButton.layer.cornerRadius = 14.0
    }

}

extension SearchDetailSummaryCell: FloatRatingViewDelegate {
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        DDLogDebug("didUpdate \(String(format: "%.2f", self.floatRatingView.rating))")
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        DDLogDebug("isUpdating \(String(format: "%.2f", self.floatRatingView.rating))")
    }
    
}
