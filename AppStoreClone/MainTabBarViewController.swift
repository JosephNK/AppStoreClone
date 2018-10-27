//
//  MainTabBarViewController.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 26..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let todayMainViewController = self.getControllerFromStoryboard(withStoryboardName: "Today", withIdentifier: "TodayMainViewController")
        todayMainViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        
        let gameMainViewController = self.getControllerFromStoryboard(withStoryboardName: "Game", withIdentifier: "GameMainViewController")
        gameMainViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 1)
        
        let appsMainViewController = self.getControllerFromStoryboard(withStoryboardName: "Apps", withIdentifier: "AppsMainViewController")
        appsMainViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 2)
        
        let updateMainViewController = self.getControllerFromStoryboard(withStoryboardName: "Update", withIdentifier: "UpdateMainViewController")
        updateMainViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 3)
        
        let searchMainViewController = self.getControllerFromStoryboard(withStoryboardName: "Search", withIdentifier: "SearchMainViewController")
        searchMainViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 4)
        
        self.viewControllers = [UINavigationController(rootViewController: todayMainViewController),
                                UINavigationController(rootViewController: gameMainViewController),
                                UINavigationController(rootViewController: appsMainViewController),
                                UINavigationController(rootViewController: updateMainViewController),
                                UINavigationController(rootViewController: searchMainViewController)]
        
        self.selectedViewController = self.viewControllers?[4]
    }

}
