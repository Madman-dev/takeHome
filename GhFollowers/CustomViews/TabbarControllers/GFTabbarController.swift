//
//  GFTabbarController.swift
//  GhFollowers
//
//  Created by Porori on 2/20/24.
//

import UIKit

final class GFTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabbar()
    }
    
    private func configureTabbar() {
        self.delegate = self
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers             = [createSearchNC(), createFavoritesNC()]
        
        //removed tabbarAppearance
//        let appearance              = UITabBarAppearance()
//        appearance.backgroundColor  = .systemBackground
//        tabBar.standardAppearance   = appearance
//        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
    }
    
    private func createSearchNC() -> UINavigationController {
        let searchVC        = SearchVC()
        //        searchVC.title      = ""
        //        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

        let customTabbarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "pencil"), tag: 0)
        searchVC.tabBarItem = customTabbarItem
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    private func createFavoritesNC() -> UINavigationController {
        let favoriteVC        = FavoriteVC()
//        favoriteVC.title      = "Favorite"
//        favoriteVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        let customTabbarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "lasso"), tag: 1)
        favoriteVC.tabBarItem = customTabbarItem
        
        return UINavigationController(rootViewController: favoriteVC)
    }
}

extension GFTabbarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0: self.title = "검색"
        case 1: self.title = "Favorite"
        default:
            return
        }
    }
}

#Preview {
    return GFTabbarController()
}
