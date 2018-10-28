//
//  SearchResultsViewController.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 23..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

@objc protocol SearchResultsViewControllerDelegate: NSObjectProtocol {
    func selectedAppTableViewRow(controller: SearchResultsViewController, bundleId: String)
}

class SearchResultsViewController: BaseTableViewController {
    
    weak var delegate: SearchResultsViewControllerDelegate? = nil
    
    weak var searchBar: UISearchBar? = nil
    
    fileprivate var dataSource: SearchResultsDataSource?
    
    //fileprivate var tableViewSeletedHandler: ((_ content: String) -> Void)? = nil
    
    deinit {
        DDLogDebug("deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = SearchResultsDataSource()
        dataSource?.searchBar = searchBar
        
        self.tableView.dataSource = dataSource
        self.tableView.separatorColor = UIColor.white
        self.tableView.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}

// MARK: - Public Method
extension SearchResultsViewController {
    
    /**
     결과 테이블뷰 숨기기
     - parameters:
     - hidden: 숨기기 여부
     */
    public func updateTableViewHidden(_ hidden: Bool) {
        self.tableView.isHidden = hidden
    }
    
    /**
     결과 테이블뷰 데이타 삭제
     */
    public func removeRows() {
        self.dataSource?.historys.removeAll()
        self.tableView.reloadData()
    }
    
    //public func addTableViewSeletedHandler(_ handler: ((_ content: String) -> Void)?) {
    //    tableViewSeletedHandler = handler
    //}
    
    /**
     서치API로 부터 APP 리스트 정보 가져오기
     - parameters:
     - searchText: 검색어
     */
    public func fetchSearchAppList(searchText: String) {
        self.removeRows()
        
        // Get App List From Serach
        SearchStorage.requestSearchList(searchText: searchText, { [weak self] (datas) in
            if datas.count == 0 {
                // Not Found Display
                self?.updateHistoryFromSearchText(searchText)
                self?.reloadAtNotFound()
            } else {
                // AppList Display
                self?.updateHistoryFromSearchText(searchText)
                self?.dataSource?.appListItems = datas
                self?.reloadAtAppList()
            }
            self?.searchBar?.resignFirstResponder()
        }) { (error) in
            
        }
    }
    
}

// MARK: - Private Method
extension SearchResultsViewController {
    
    /**
     타이핑 된 검색어로 부터 최근 검색어에 매칭되는 리스트 가져오기
     - parameters:
     - searchText: 검색어
     */
    fileprivate func filterRowsFetchForSearchedText(_ searchText: String) {
        // Search History Fetch
        HistoryCoreData.shared.fetch(search: searchText) { [weak self] (results) in
            self?.dataSource?.historys.removeAll()
            for result in results {
                self?.dataSource?.historys.append(result)
            }
            self?.reloadAtHistory()
        }
    }
    
    /**
     검색어 코어데이터에 저장하기
     - parameters:
     - text: 검색어
     */
    fileprivate func updateHistoryFromSearchText(_ text: String) {
        if !text.isEmpty {
            // Search Word Save & Update
            HistoryCoreData.shared.updateWithSave(withContent: text, withDate: Date())
        }
    }
    
    /**
     최근 검색어 타입으로 리로드
     */
    fileprivate func reloadAtHistory() {
        // Reload History UI
        dataSource?.currentResultType = .history
        self.tableView.reloadData()
        self.tableView.isScrollEnabled = true
    }
    
    /**
     앱리스트 타입으로 리로드
     */
    fileprivate func reloadAtAppList() {
        // Reload AppList UI
        dataSource?.currentResultType = .applist
        self.tableView.reloadData()
        self.tableView.isScrollEnabled = true
    }
    
    /**
     결과없음 타입으로 리로드
     */
    fileprivate func reloadAtNotFound() {
        // Reload Notfound UI
        dataSource?.currentResultType = .notfound
        self.tableView.reloadData()
        self.tableView.isScrollEnabled = false
    }
    
}

// MARK: - UITableViewDelegate
extension SearchResultsViewController {
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let currentResultType = dataSource?.currentResultType else {
            return UITableView.automaticDimension
        }
        switch currentResultType {
        case .history, .applist:
            break
        case .notfound:
            return tableView.frame.size.height
        }
        
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentResultType = dataSource?.currentResultType else {
            return
        }
        
        switch currentResultType {
        case .history:
            let item = self.dataSource?.historys[safe: indexPath.item]
            if let content = item?.content {
                //if let handler = self.tableViewSeletedHandler {
                //    handler(content)
                //}
                self.fetchSearchAppList(searchText: content)    // API Request Fetch
            }
            break
        case .applist:
            if let item = self.dataSource?.appListItems?[safe: indexPath.item], let bundleId = item.bundleId {
                delegate?.selectedAppTableViewRow(controller: self, bundleId: bundleId)
            }
            break
        case .notfound:
            break
        }
    }
    
}

// MARK: - UISearchResultsUpdating
extension SearchResultsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        self.dataSource?.searchWord = searchText
        self.updateTableViewHidden((searchText == "") ? true : false)
        self.filterRowsFetchForSearchedText(searchText)
    }
    
}

// MARK: - DelegateProxy
class RXSearchResultsDelegateProxy: DelegateProxy<SearchResultsViewController, SearchResultsViewControllerDelegate>, DelegateProxyType, SearchResultsViewControllerDelegate {
    // Typed parent object.
    public weak private(set) var controller: SearchResultsViewController?
    
    internal let didAppSelectedRow = PublishSubject<(controller: SearchResultsViewController, bundleId: String)>()
    
    // parent object for delegate proxy.
    public init(parentObject: SearchResultsViewController) {
        self.controller = parentObject
        super.init(parentObject: parentObject, delegateProxy: RXSearchResultsDelegateProxy.self)
    }
    
    // Register known implementationss. (from DelegateProxyType)
    static func registerKnownImplementations() {
        self.register { RXSearchResultsDelegateProxy(parentObject: $0) }
    }
    
    // read the current delegate. (from DelegateProxyType)
    static func currentDelegate(for object: SearchResultsViewController) -> SearchResultsViewControllerDelegate? {
        return object.delegate
    }
    
    // set the current delegate. (from DelegateProxyType)
    static func setCurrentDelegate(_ delegate: SearchResultsViewControllerDelegate?, to object: SearchResultsViewController) {
        object.delegate = delegate as? RXSearchResultsDelegateProxy
    }

    // delegate method
    internal func selectedAppTableViewRow(controller: SearchResultsViewController, bundleId: String) {
        didAppSelectedRow.onNext((controller, bundleId))
    }
    
    // dispose the publish subject
    deinit {
        didAppSelectedRow.on(.completed)
    }
}

// MARK: - Custom with the Reactive delegate and its protocol function
extension Reactive where Base: SearchResultsViewController {
    /// Reactive wrapper for `delegate`.
    /// For more information take a look at `DelegateProxyType` protocol documentation.
    fileprivate var delegate: RXSearchResultsDelegateProxy {
        return RXSearchResultsDelegateProxy.proxy(for: base)
    }
    
    internal func setDelegate(_ delegate: SearchResultsViewControllerDelegate) -> Disposable {
        return RXSearchResultsDelegateProxy
            .installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
    }
    
    internal var rx_didAppSelectedRow: ControlEvent<(controller: SearchResultsViewController, bundleId: String)> {
        return ControlEvent(events: delegate.didAppSelectedRow)
    }
}
