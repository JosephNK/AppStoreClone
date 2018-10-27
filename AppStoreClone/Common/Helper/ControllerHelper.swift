//
//  ControllerHelper.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 23..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func getControllerFromStoryboard(withStoryboardName name: String, withIdentifier identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        return controller
    }
    
    func pushViewControllerByStoryboard(withStoryboardName name: String, withIdentifier identifier: String, beforePush: ((_ controller: UIViewController) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        if let c = beforePush {
            c(controller)
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }

}

extension UIViewController {
    
    func removeBottomLineFormSearchController(_ searchController: UISearchController) {
        let lineView = UIView(frame: CGRect(x: 0, y: searchController.searchBar.frame.height-4, width: self.view.bounds.width, height: 1))
        lineView.backgroundColor = .white
        searchController.searchBar.addSubview(lineView)
    }
    
}

extension UIViewController {
    
    func applyLargeTitleWithSearchNavigationBar(_ searchController: UISearchController) {
        // Large Title Setup
        self.definesPresentationContext = true
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                             NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)]
    }
    
}

extension UIViewController {
    
    func getCustomTitleImageView(withImage image: UIImage?) -> UIImageView? {
        let titleImgView = UIImageView.init(frame: CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0))
        titleImgView.backgroundColor = UIColor.clear
        titleImgView.image = image
        titleImgView.layer.cornerRadius = 8.0
        titleImgView.clipsToBounds = true
        return titleImgView
    }
    
    func getCustomBarButton(title: String, backgroundColor: UIColor) -> (barItem: UIBarButtonItem, button: UIButton) {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.bold)
        button.backgroundColor = backgroundColor
        button.contentEdgeInsets = UIEdgeInsets(top: 6.0, left: 24.0, bottom: 6.0, right: 24.0)
        button.layer.cornerRadius = 14.0
        return (UIBarButtonItem(customView: button), button)
    }
    
}

