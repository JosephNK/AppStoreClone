//
//  SearchDetailWhatsNewCell.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 24..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

class SearchDetailWhatsNewCell: BaseTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var showVersionButton: UIButton!
    @IBOutlet weak var readMoreLabelView: ReadMoreLabelView!
    
    var model: SearchResultModel? {
        didSet {
            let version = model?.version ?? ""
            let releaseNotes = model?.releaseNotes ?? ""
            let releaseDate = model?.releaseDate
            
            self.versionLabel.text = "\(NSLocalizedString("Version", comment: "")) \(version)"
            self.dayLabel.text = Date.timeAgoSince(releaseDate)
            self.readMoreLabelView.text = releaseNotes
            
            self.titleLabel.text = NSLocalizedString("WhatsNew", comment: "")
            self.showVersionButton.setTitle(NSLocalizedString("ShowVersion", comment: ""), for: UIControl.State.normal)
            self.readMoreLabelView.readMoreTitle = NSLocalizedString("ReadMore", comment: "")
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

    /**
     읽었는지 안읽었는지 처리하는 함수
     - parameters:
     - isReadMoreValue: 읽었는지 안읽었는지 Bool 값
     */
    public func updateReadMore(_ isReadMoreValue: Bool) {
        let text = self.model?.releaseNotes ?? ""
        
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
            //DDLogDebug("[SearchDetailWhatsNewCell] frame: \(self.frame) readMoreLabelView.size: \(labelViewSize), actualHeight: \(actualHeight)")
            if actualHeight >= CGFloat(labelViewSize.height) {
                self.isReadMore = false
            } else {
                self.isReadMore = true
            }
        }
    }
    
}
