//
//  SearchResultsDataSource.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 27..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

enum SearchResultType {
    case history
    case applist
    case notfound
}

class SearchResultsDataSource: NSObject, UITableViewDataSource {

    weak var searchBar: UISearchBar?
    
    var historys: [HistoryEntity] = []
    
    var appListItems: [SearchResultModel]?
    
    var currentResultType: SearchResultType = .history
    
    var searchWord: String = ""
    
    //
    // MARK: - UITableViewDataSource
    //
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.currentResultType {
        case .history:
            return historys.count
        case .applist:
            return appListItems?.count ?? 0
        case .notfound:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.currentResultType {
        case .history:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultsHistoryCell") as? SearchResultsHistoryCell {
                cell.searchWord = self.searchWord
                cell.historyItem = self.historys[safe: indexPath.item]
                return cell
            }
        case .applist:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultsAppListCell", for: indexPath) as? SearchResultsAppListCell {
                cell.model = self.appListItems?[safe: indexPath.item]
                return cell
            }
        case .notfound:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultsAppListNotFoundCell", for: indexPath) as? SearchResultsAppListNotFoundCell {
                cell.contentLabel.text = "'\(searchBar?.text ?? "")'"
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
}
