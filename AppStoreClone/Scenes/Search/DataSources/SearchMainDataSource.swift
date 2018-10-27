//
//  SearchMainDataSource.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 27..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

class SearchMainDataSource: NSObject, UITableViewDataSource {
    
    var historys: [HistoryEntity] = []
    
    //
    // MARK: - UITableViewDataSource
    //
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchMainHistoryCell", for: indexPath) as? SearchMainHistoryCell {
            cell.historyItem = self.historys[safe: indexPath.item]
            return cell
        }
        
        return UITableViewCell()
    }
    
}
