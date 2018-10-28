//
//  SearchDetailDataSource.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 27..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

class SearchDetailDataSource: NSObject, UITableViewDataSource {

    /// App 정보 데이타 모델
    var lookupItem: SearchResultModel?
    
    /// App 정보 데이타 중 Infomation 부분 데이타 모델 리스트
    var infoModels: [SearchInfoListModel] = []
    
    /// Expand시 스크롤 관련 하여 체크하는 변수
    var scrollPostionReturnValue: Bool = false
    
    /// Expand 된 IndexPath 정보 담는 배열
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
    
    /**
     IndexPath로 부터 Expand 되었는지 체크 하는 함수
     - parameters:
     - indexPath: indexPath
     */
    func isCellAtExpanded(at indexPath: IndexPath) -> Bool {
        return cellExpandIndexPaths.contains(indexPath)
    }
    
    /**
     IndexPath로 부터 배열에 저장 하는 함수
     - parameters:
     - indexPath: indexPath
     */
    func addCellAtExpandedIndexPath(_ indexPath: IndexPath) {
        if self.isCellAtExpanded(at: indexPath) == true {
            return
        }
        cellExpandIndexPaths.insert(indexPath)
    }
    
    /**
     IndexPath로 부터 배열에 삭제 하는 함수
     - parameters:
     - indexPath: indexPath
     */
    func removeCellAtExpandedIndexPath(_ indexPath: IndexPath) {
        cellExpandIndexPaths.remove(indexPath)
    }
    
}
