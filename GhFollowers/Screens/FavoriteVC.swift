//
//  FavoriteVC.swift
//  GhFollowers
//
//  Created by Porori on 2/2/24.
//

import UIKit

class FavoriteVC: GFDataLoadingVC {
    
    let tableview = UITableView()
    var favorites: [Follower] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        getFavorites()
    }
    
    func configureViewController() {
        view.backgroundColor    = .systemBackground
        title                   = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView() {
        view.addSubview(tableview)
        tableview.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseId)
        tableview.frame = view.bounds
        tableview.rowHeight = 80
        
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let favorited):
                print(favorited)
                if favorited.isEmpty {
                    showEmptyStateView(with: "오잉?\nFavorite한 멤버가 없습니다", in: self.view)
                } else {
                    self.favorites = favorited
                    DispatchQueue.main.async {
                        self.tableview.reloadData()
                        // 혹시 emptyview가 먼저 보일 경우? when populated AFTERWARDS
                        self.view.bringSubviewToFront(self.tableview)
                    }
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "뭘까요", message: error.localizedDescription, buttonTitle: "Ok")
            }
        }
    }
}

extension FavoriteVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseId) as! FavoriteCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        
        let destinationVC = FollowerListVC(username: favorite.login)
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let favorite = favorites[indexPath.row]
        favorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        // update the Userdefault data
        PersistenceManager.updateWith(follower: favorite, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else { return } // no error
            self.presentGFAlertOnMainThread(title: "오류가 발생했습니다.", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}
