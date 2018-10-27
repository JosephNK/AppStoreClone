//
//  SearchDetailViewController.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 23..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum SearchDetailSectionType: Int {
    case summary = 0
    case whatnew
    case screenshot
    case desc
    case info
}

class SearchDetailViewController: BaseTableViewController {
    
    public var bundleId: String? {
        didSet {
            
        }
    }
    
    fileprivate var dataSource: SearchDetailDataSource? = nil
    
    deinit {
        DDLogDebug("deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = SearchDetailDataSource()
        
        self.tableView.dataSource = dataSource
        self.tableView.separatorColor = UIColor.white
        
        self.tableView.register(SearchDetailHeaderView.self, forHeaderFooterViewReuseIdentifier: "SearchDetailHeaderView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        fetchSearchLookup(bundleId: self.bundleId ?? "")
    }
    
}

// MARK: - Public Method
extension SearchDetailViewController {

}

// MARK: - Private Method
extension SearchDetailViewController {
    
    fileprivate func fetchSearchLookup(bundleId: String) {
        if bundleId.isEmpty {
            return
        }
        
        // Get Lookup App Info From Serach
        SearchStorage.requestSearchLookup(bundleId: bundleId, { [weak self] (datas) in
            if datas.count == 0 {
                return
            }
            
            // Setup Lookup App Info & AppList Display
            self?.dataSource?.lookupItem = datas[safe: 0]
            
            if let item = self?.dataSource?.lookupItem {
                self?.dataSource?.infoModels = SearchInfoListModel.makeListFromItem(item)
            }
            
            self?.tableView.reloadData()
        }) { (error) in
            
        }
    }
    
    fileprivate func updateNavigationBarView() {
        if self.navigationItem.titleView == nil {
            if let artworkUrl60 = self.dataSource?.lookupItem?.artworkUrl60 {
                let imageView = self.getCustomTitleImageView(withImage: nil)
                imageView?.setCacheImageURL(URL(string: artworkUrl60))
                self.navigationItem.titleView = imageView
            }
            self.navigationItem.rightBarButtonItem = self.getCustomBarButton(title: NSLocalizedString("Download", comment: ""),
                                                                             backgroundColor: UIColor(hexString: "#0066FF")).barItem
        }
    }
    
}

// MARK: - UITableViewDelegate
extension SearchDetailViewController {
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 55.5
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let tableSection = SearchDetailSectionType(rawValue: section) {
            switch tableSection {
            case .summary, .whatnew, .desc:
                break
            case .screenshot, .info:
                return 55.0
            }
        }
        
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let tableSection = SearchDetailSectionType(rawValue: section) {
            if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SearchDetailHeaderView") as? SearchDetailHeaderView {
                switch tableSection {
                case .summary, .whatnew, .desc:
                    break
                case .screenshot:
                    header.titleLabel.text = NSLocalizedString("Preview", comment: "")
                    break
                case .info:
                    header.titleLabel.text = NSLocalizedString("Infomation", comment: "")
                    break
                }
                return header
            }
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tableSection = SearchDetailSectionType(rawValue: indexPath.section) {
            if tableSection == .info {
                let model = self.dataSource?.infoModels[safe: indexPath.item]
                let useExpand = model?.useExpand ?? false
                if let cell = tableView.cellForRow(at: indexPath) as? SearchDetailExpandCell, useExpand == true {
                    cell.openExpand()
                    
                    self.dataSource?.scrollPostionReturnValue = true
                    
                    UIView.setAnimationsEnabled(false)
                    tableView.beginUpdates()
                    tableView.endUpdates()
                    UIView.setAnimationsEnabled(true)
                }
            }
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPostionReturnValue = self.dataSource?.scrollPostionReturnValue ?? false
        if scrollPostionReturnValue {
            self.dataSource?.scrollPostionReturnValue = false
            return
        }
        
        let posY = scrollView.contentOffset.y
        DDLogDebug("scrollViewDidScroll Postion Y Value = \(posY)")
        
        let checkPosY: CGFloat = 110.0
        if posY <= checkPosY {
            self.navigationItem.titleView = nil
            self.navigationItem.rightBarButtonItem = nil
        }
        if posY > checkPosY {
            self.updateNavigationBarView()
        }
    }
    
}
