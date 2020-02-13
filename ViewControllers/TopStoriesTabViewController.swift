//
//  TopStoriesTabViewController.swift
//  NYTTopStories
//
//  Created by Liubov Kaper  on 2/6/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import UIKit
import DataPersistence

class TopStoriesTabViewController: UITabBarController {
    
    
    // step 1: setting up data persistance and its delegate
    private var dataPersistance = DataPersistence<Article>(filename: "savedArticles.plist")
    
    
    private lazy var newsFeedVC: NewsFeedViewController = {
        let viewController = NewsFeedViewController(dataPersistance)
        viewController.tabBarItem = UITabBarItem(title: "News Feed", image: UIImage(systemName: "eyeglasses"), tag: 0)
        // don't need line below, because we injecting now through initializer
        //viewController.dataPersistance = dataPersistance
        return viewController
    }()
    
    private lazy var savedArticlesVC: SavedArticlesViewController = {
        let viewController = SavedArticlesViewController(dataPersistance)
        viewController.tabBarItem = UITabBarItem(title: "Saved Articles", image: UIImage(systemName: "folder"), tag: 1)
        //viewController.dataPersistance = dataPersistance
        //steps  setting up data persistance and delegate:
        // setting up delegate here
        //viewController.dataPersistance.delegate = viewController
        return viewController
    }()
    
    private lazy var settingsVC: SettingsViewController = {
        let viewController = SettingsViewController()
        viewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemYellow
        viewControllers = [UINavigationController(rootViewController: newsFeedVC),          UINavigationController(rootViewController:savedArticlesVC),     UINavigationController(rootViewController:settingsVC)]
    }
    

   
}
