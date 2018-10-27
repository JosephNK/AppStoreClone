//
//  SearchDetailDescCell.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 23..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

class SearchDetailDescCell: BaseTableViewCell {
    
    @IBOutlet weak var readMoreLabelView: ReadMoreLabelView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var model: SearchResultModel? {
        didSet {
            let sellerName = model?.sellerName ?? ""
            let description = model?.description ?? ""
            
            self.titleLabel.text = sellerName
            self.readMoreLabelView.text = description
            
            self.readMoreLabelView.readMoreTitle = NSLocalizedString("ReadMore", comment: "")
            self.descLabel.text = NSLocalizedString("Developer", comment: "")
        }
    }
    
    private var isReadMore: Bool = false {
        didSet {
            readMoreLabelView.isReadMoreButtonHidden(isReadMore)
            readMoreLabelView.textNumberLineCount = isReadMore ? 0 : 3
        }
    }
    
    override func initialization() {
        super.initialization()
    }
    
    public func updateReadMore(_ isReadMoreValue: Bool) {
        let text = self.model?.description ?? ""
        
        if text.isEmpty {
            readMoreLabelView.isReadMoreButtonHidden(true)
            return
        }
        if isReadMoreValue == true {
            isReadMore = true
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let labelViewSize = self.readMoreLabelView.frame.size
            let labelViewFont = self.readMoreLabelView.textFont
            let actualHeight = text.height(withConstrainedWidth: labelViewSize.width, font: labelViewFont)
            //DDLogDebug("[SearchDetailDescCell] frame: \(self.frame) readMoreLabelView.size: \(labelViewSize), actualHeight: \(actualHeight)")
            if actualHeight > CGFloat(labelViewSize.height) {
                self.isReadMore = false
            } else {
                self.isReadMore = true
            }
        }
    }

}


