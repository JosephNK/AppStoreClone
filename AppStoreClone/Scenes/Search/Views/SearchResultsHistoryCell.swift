//
//  SearchResultsHistoryCell.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 23..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

class SearchResultsHistoryCell: BaseTableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var searchWord: String = ""
    
    var historyItem: HistoryEntity? {
        didSet {
            let content = historyItem?.content ?? ""
            
            if !searchWord.isEmpty {
                titleLabel.changePartColor(fullText: content, changeText: searchWord)
            } else {
                titleLabel.text = content
            }
        }
    }
    
    override func initialization() {
        super.initialization()
        
        self.contentView.setBottomLine()
    }

}
