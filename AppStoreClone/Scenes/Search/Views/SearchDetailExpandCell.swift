//
//  SearchDetailExpandCell.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 23..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

class SearchDetailExpandCell: BaseTableViewCell {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dataLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var arrowImgView: UIImageView!
    
    @IBOutlet private weak var arrowRightConstraint: NSLayoutConstraint!
    
    private let expandedViewIndex: Int = 1
    private var defaultArrowRightConstraintValue: CGFloat = 0.0
    
    var model: SearchInfoListModel? {
        didSet {
            let title = model?.title ?? ""
            let subtitle = model?.subtitle ?? ""
            let desc = model?.desc ?? ""
            let useExpand = model?.useExpand ?? false
            let expandState = model?.expandState ?? .collapsed
            
            titleLabel.text = title
            dataLabel.text = subtitle
            descriptionLabel.text = desc
            
            self.stackView.arrangedSubviews[expandedViewIndex].isHidden = (expandState == .collapsed) ? true : false
            
            self.arrowImgView.isHidden = useExpand ? false : true
            self.arrowRightConstraint.constant = useExpand ? 22 : 0
        }
    }
    
    override func initialization() {
        super.initialization()
    }
    
    // MARK: Public Method
    public func openExpand() {
        model?.useExpand = false
        model?.expandState = .expanded
        
        self.stackView.arrangedSubviews[expandedViewIndex].isHidden = false
        
        UIView.animate(withDuration: 0.25, animations: {
            self.dataLabel.alpha = 0.0
            self.arrowImgView.alpha = 0.0
        }) { (finished) in
            if finished {
                self.dataLabel.isHidden = true
                self.arrowImgView.isHidden = true
            }
        }
    }

    // MARK: Private Method
    private func updateArrowImageHidden(_ hidden: Bool) {
        arrowImgView.isHidden = hidden
        arrowRightConstraint.constant = hidden ? 0 : 35
    }
}
