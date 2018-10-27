//
//  SearchMainHistoryCell.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 23..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

class SearchMainHistoryCell: BaseTableViewCell {

    var historyItem: HistoryEntity? {
        didSet {
            let content = historyItem?.content ?? ""
            
            self.textLabel?.text = content
        }
    }
    
    override func initialization() {
        super.initialization()
        
        self.contentView.setBottomLine()
    }
    
}
