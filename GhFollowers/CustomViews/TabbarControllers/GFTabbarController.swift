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
        self.delegate = self
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
        //        searchVC.title      = ""
        //        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

        let customTabbarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "pencil"), tag: 0)
        searchVC.tabBarItem = customTabbarItem
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    func createFavoritesNC() -> UINavigationController {
        let favoriteVC        = FavoriteVC()
//        favoriteVC.title      = "Favorite"
//        favoriteVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        let customTabbarItem = UITabBarItem(title: "커스텀", image: UIImage(systemName: "lasso"), tag: 1)
        favoriteVC.tabBarItem = customTabbarItem
        favoriteVC.tabBarItem.tag = 1
        
        return UINavigationController(rootViewController: favoriteVC)
    }
}

extension GFTabbarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            item.title = "눌렸나?"
            tabBar.items?[1].title = ""
        case 1:
            item.title = "Noolyutnat?"
            tabBar.items?[0].title = ""
        default:
            return
        }

//        if item.tag == 0 {
//            item.title = "눌림"
//            tabBar.items?[1].title = ""
//        }
//        
//        if item.tag == 1 {
//            item.title = "눌림"
//            tabBar.items?[0].title = ""
//        }
    }
}
