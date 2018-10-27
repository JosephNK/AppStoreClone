//
//  SearchResultsAppListNotFoundCell.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 26..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

class SearchResultsAppListNotFoundCell: BaseTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func initialization() {
        super.initialization()
        
        self.titleLabel.text = NSLocalizedString("NotFound", comment: "")
    }
    
}
