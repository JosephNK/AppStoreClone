//
//  SearchDetailDataSource.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 27..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

class SearchDetailDataSource: NSObject, UITableViewDataSource {

    var lookupItem: SearchResultModel?
    
    var infoModels: [SearchInfoListModel] = []
    
    var scrollPostionReturnValue: Bool = false
    
    fileprivate var cellExpandIndexPaths: Set<IndexPath> = []
    
    //
    // MARK: - UITableViewDataSource
    //
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tableSection = SearchDetailSectionType(rawValue: section) {
            switch tableSection {
            case .summary, .whatnew, .screenshot, .desc:
                return 1
            case .info:
                return infoModels.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tableSection = SearchDetailSectionType(rawValue: indexPath.section) {
            switch tableSection {
            case .summary:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchDetailSummaryCell") as? SearchDetailSummaryCell  {
                    cell.model = self.lookupItem
                    return cell
                }
                break
            case .whatnew:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchDetailWhatsNewCell") as? SearchDetailWhatsNewCell  {
                    cell.model = self.lookupItem
                    cell.updateReadMore(self.isCellAtExpanded(at: indexPath) ? true : false)
                    cell.readMoreLabelView.addReadMoreClicked { [weak self] (labelView) in
                        self?.addCellAtExpandedIndexPath(indexPath)
                        
                        self?.scrollPostionReturnValue = true
                        
                        tableView.reloadSections(IndexSet(integer: SearchDetailSectionType.whatnew.rawValue), animated: false)
                    }
                    return cell
                }
                break
            case .screenshot:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchDetailPreviewCell") as? SearchDetailPreviewCell  {
                    cell.model = self.lookupItem
                    return cell
                }
                break
            case .desc:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchDetailDescCell") as? SearchDetailDescCell  {
                    cell.model = self.lookupItem
                    cell.updateReadMore(self.isCellAtExpanded(at: indexPath) ? true : false)
                    cell.readMoreLabelView.addReadMoreClicked { [weak self] (labelView) in
                        self?.addCellAtExpandedIndexPath(indexPath)
                        
                        self?.scrollPostionReturnValue = true
                        
                        tableView.reloadSections(IndexSet(integer: SearchDetailSectionType.desc.rawValue), animated: false)
                    }
                    return cell
                }
                break
            case .info:
                let infoModel = self.infoModels[safe: indexPath.item]
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchDetailExpandCell") as? SearchDetailExpandCell  {
                    cell.model = infoModel
                    return cell
                }
                break
            }
        }
        
        return UITableViewCell()
    }
    
}

extension SearchDetailDataSource {
    
    func isCellAtExpanded(at indexPath: IndexPath) -> Bool {
        return cellExpandIndexPaths.contains(indexPath)
    }
    
    func addCellAtExpandedIndexPath(_ indexPath: IndexPath) {
        if self.isCellAtExpanded(at: indexPath) == true {
            return
        }
        cellExpandIndexPaths.insert(indexPath)
    }
    
    func removeCellAtExpandedIndexPath(_ indexPath: IndexPath) {
        cellExpandIndexPaths.remove(indexPath)
    }
    
}
