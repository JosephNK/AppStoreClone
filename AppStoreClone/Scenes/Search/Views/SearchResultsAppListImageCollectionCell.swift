//
//  SearchResultsAppListImageCollectionCell.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 26..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

class SearchResultsAppListImageCollectionCell: BaseCollectionViewCell {
 
    @IBOutlet weak var imageView: UIImageView!
    
    var imageUrl: String? {
        didSet {
            let imgUrl = imageUrl ?? ""
            
            self.imageView.setCacheImageURL(URL(string: imgUrl))
        }
    }
    
    override func initialization() {
        super.initialization()
    }
    
}
