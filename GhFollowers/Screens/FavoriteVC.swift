//
//  FavoriteVC.swift
//  GhFollowers
//
//  Created by Porori on 2/2/24.
//

import UIKit

class FavoriteVC: GFDataLoadingVC {
    
    let tableview               = UITableView()
    var favorites: [Follower]   = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        getFavorites()
    }
    
    private func configureViewController() {
        view.backgroundColor    = .systemBackground
        title                   = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        view.addSubview(tableview)
        tableview.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseId)
        tableview.frame         = view.bounds
        tableview.rowHeight     = 80
        
        tableview.delegate      = self
        tableview.dataSource    = self
        tableview.removeExcessiveCells()
    }
    
    private func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let favorited):
                self.updateUI(with: favorited)
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentGFAlert(title: "뭘까요", message: error.localizedDescription, buttonTitle: "Ok")
                }
            }
        }
    }
    
    private func updateUI(with favorited: [Follower]) {
        if favorited.isEmpty {
            self.showEmptyStateView(with: "오잉?\nFavorite한 멤버가 없습니다", in: self.view)
        } else {
            self.favorites = favorited
            DispatchQueue.main.async {
                self.tableview.reloadData()
                self.view.bringSubviewToFront(self.tableview)
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
        
        PersistenceManager.updateWith(follower: favorites[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.favorites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                return
            } // when error occurs, the current code structure would make data out of sync if removed tableview deletes data first
            DispatchQueue.main.async {
                self.presentGFAlert(title: "오류가 발생했습니다.", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}
