//
//  SearchMainViewController.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 23..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SearchMainViewController: BaseTableViewController {
    
    let disposeBag = DisposeBag()
    
    fileprivate var dataSource: SearchMainDataSource?
    
    fileprivate lazy var searchResultsController: SearchResultsViewController = {
        let controller = self.getControllerFromStoryboard(withStoryboardName: "Search", withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        return controller
    }()
    
    fileprivate lazy var searchController: UISearchController = {
        var controller = UISearchController(searchResultsController: self.searchResultsController)
        //controller.delegate = self
        controller.searchResultsUpdater = self.searchResultsController
        controller.searchBar.delegate = self
        controller.searchBar.placeholder = NSLocalizedString("SearchBarPlaceholder", comment: "App Store")
        controller.dimsBackgroundDuringPresentation = true
        return controller
    }()
    
    deinit {
        DDLogDebug("deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = SearchMainDataSource()
        
        self.tableView.dataSource = dataSource
        self.tableView.separatorColor = UIColor.white
        self.tableView.backgroundColor = UIColor.white
        
        searchResultsController.searchBar = searchController.searchBar
        
        // NaigationItem Title
        self.navigationItem.title = NSLocalizedString("SearchNavTitle", comment: "Search")
        
        // Large Title Setup
        self.applyLargeTitleWithSearchNavigationBar(self.searchController)
        
        // Remove Line
        self.removeBottomLineFormSearchController(self.searchController)
        
        // SearchMainHistoryHeaderView Register
        self.tableView.register(SearchMainHistoryHeaderView.self, forHeaderFooterViewReuseIdentifier: "SearchMainHistoryHeaderView")
        
        // Bind
        self.bindRxBySearchController()
        self.bindRxBySearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.fetchHistoryCoreData()
    }
    
}

// MARK: - Public Method
extension SearchMainViewController {
    
}

// MARK: - Private Method
extension SearchMainViewController {
    
    fileprivate func fetchHistoryCoreData() {
        // Search History Fetch
        HistoryCoreData.shared.fetch { [weak self] (results) in
            self?.dataSource?.historys.removeAll()
            for result in results {
                self?.dataSource?.historys.append(result)
            }
            self?.tableView.reloadData()
        }
    }
    
    fileprivate func activeSearchBarByContent(_ content: String) {
        self.searchController.searchBar.text = content
        self.searchController.isActive = true
    }
    
}

// MARK: - UITableViewDelegate
extension SearchMainViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let history = dataSource?.historys[safe: indexPath.item]
        
        guard let content = history?.content else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.activeSearchBarByContent(content)  // Active SearchBar
            self.searchResultsController.fetchSearchAppList(searchText: content)    // API Request Fetch
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 55.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SearchMainHistoryHeaderView") as? SearchMainHistoryHeaderView {
            header.titleLabel.text = NSLocalizedString("SearchRecentTitle", comment: "")
            return header
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
}

// MARK: - UISearchBarDelegate
extension SearchMainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.isEmpty || text == "\n" {
            return true
        }
        
        return String.checkRegularOnlyKorean(text)
    }
    
}

// MARK: - RxSwift Bind
extension SearchMainViewController {
    
    func bindRxBySearchController() {
        /*
        searchController.rx
            .willPresent
            .subscribe { [unowned self] (event) in
                
            }.disposed(by: disposeBag)
        */
        
        searchController.rx
            .willDismiss
            .subscribe { [unowned self] (event) in
                self.fetchHistoryCoreData()
            }.disposed(by: disposeBag)
        
        searchResultsController.rx
            .rx_didAppSelectedRow
            .subscribe { [unowned self] (event) in
                switch event {
                case .next(_, let bundleId):
                    DDLogDebug("next \(bundleId)")
                    self.pushViewControllerByStoryboard(withStoryboardName: "Search", withIdentifier: "SearchDetailViewController") { (controller) in
                        guard let controller = controller as? SearchDetailViewController else {
                            return
                        }
                        controller.bundleId = bundleId
                    }
                    break
                case .error(let error):
                    DDLogDebug("error \(error)")
                    break
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)
    }
    
    func bindRxBySearchBar() {
        /*
        searchController.searchBar.rx.text.orEmpty
            //.debounce(0.5, scheduler: MainScheduler.instance)
            //.distinctUntilChanged().filter { !$0.isEmpty }
            .skip(1)
            .subscribe { [unowned self] (event) in
                switch event {
                case .next(let value):
                    DDLogDebug("next \(value)")
                    break
                case .error(let error):
                    DDLogDebug("error \(error)")
                    break
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)
        
        searchController.searchBar.rx
            .cancelButtonClicked
            .subscribe { [unowned self] (event) in
                switch event {
                case .next(_):
                    break
                case .error(let error):
                    DDLogDebug("error \(error)")
                    break
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)
        */
        
        searchController.searchBar.rx
            .searchButtonClicked
            .subscribe { [unowned self] (event) in
                switch event {
                case .next(_):
                    if let text = self.searchController.searchBar.text {
                        self.searchResultsController.fetchSearchAppList(searchText: text)   // API Request Fetch
                    }
                    break
                case .error(let error):
                    DDLogDebug("error \(error)")
                    break
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)
    }
    
}
