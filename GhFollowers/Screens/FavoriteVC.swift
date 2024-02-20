//
//  FavoriteVC.swift
//  GhFollowers
//
//  Created by Porori on 2/2/24.
//

import UIKit

class FavoriteVC: UIViewController {
    
    var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        PersistenceManager.retrieveFavorites { result in
            switch result {
            case .success(let favorited):
                print(favorited)
            case .failure(let error):
                break
            }
        }
    }
}
