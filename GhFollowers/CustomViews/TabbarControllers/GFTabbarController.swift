//
//  GFTabbarController.swift
//  GhFollowers
//
//  Created by Porori on 2/20/24.
//

import UIKit

class GFTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabbar()
    }
    
    func configureTabbar() {
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers             = [createSearchNC(), createFavoritesNC()]
        
        //removed tabbarAppearance
//        let appearance              = UITabBarAppearance()
//        appearance.backgroundColor  = .systemBackground
//        tabBar.standardAppearance   = appearance
//        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
    }
    
    func createSearchNC() -> UINavigationController {
        let searchVC        = SearchVC()
        searchVC.title      = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    func createFavoritesNC() -> UINavigationController {
        let favoriteVC        = FavoriteVC()
        favoriteVC.title      = "Favorite"
        favoriteVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return UINavigationController(rootViewController: favoriteVC)
    }
}
