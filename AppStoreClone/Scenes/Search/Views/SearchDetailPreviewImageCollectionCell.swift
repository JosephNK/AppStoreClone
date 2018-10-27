//
//  SearchDetailPreviewImageCollectionCell.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 26..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

class SearchDetailPreviewImageCollectionCell: BaseCollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageUrl: String? {
        didSet {
            let imgUrl = imageUrl ?? ""
            
            self.imageView.setCacheImageURL(URL(string: imgUrl))
            
//            self.imageView.setCacheImageURL(URL(string: imgUrl)) { [weak self] (image) in
//                if let size = self?.frame.size {
//                    let resizeImg = UIImage.resizeImage(image: image, targetSize: CGSize(width: size.width, height: size.height))
//                    self?.imageView.image = resizeImg
//                }
//            }
        }
    }
    
    override func initialization() {
        super.initialization()
    }
    
}
