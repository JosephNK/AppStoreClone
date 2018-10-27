//
//  SearchMainHistoryHeaderView.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 26..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

class SearchMainHistoryHeaderView: BaseTableViewHeaderFooterView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Section Header"
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)
        label.textColor = UIColor.black
        return label
    }()
    
    override func initialization() {
        super.initialization()
        
        self.contentView.backgroundColor = UIColor.white
        
        self.contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(20.0)
            make.right.equalTo(self.contentView).offset(-20.0)
            make.bottom.equalTo(self.contentView).offset(-8.0)
        }
        
        self.contentView.setBottomLine()
    }
    
}
