//
//  FollowerListVC.swift
//  GhFollowers
//
//  Created by Porori on 2/4/24.
//

import UIKit

protocol FollowerListVCDelegate: AnyObject {
    func didRequestFollower(for username: String)
}

class FollowerListVC: GFDataLoadingVC {
    
    enum Section { case main }
    
    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    var page: Int = 1
    var hasMoreFollowers: Bool = true
    var isSearching: Bool = false
    var isLoadingFollowers: Bool = false
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureSearchController()
        getFollowers(username: username, page: page)
        configureDataSource()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds,
                                          collectionViewLayout: UIHelper.createThreeColumnFlowlayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseId)
        collectionView.delegate = self
    }
    
    @objc func addButtonTapped() {
        showLoadingView() // due to network call
        
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let user):
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                
                PersistenceManager.updateWith(follower: favorite, actionType: .add) { [weak self] error in
                    guard let self = self else { return }
                    guard let error = error else {
                        self.presentGFAlertOnMainThread(title: "성공!", message: "저장되었습니다.", buttonTitle: "Ok")
                        return
                    }
                    
                    // 에러 있을 경우
                    self.presentGFAlertOnMainThread(title: "뭔가 잘못됐어요", message: error.rawValue, buttonTitle: "Ok")
                }
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "뭔가 잘못됐습니다.", message: error.rawValue, buttonTitle: "OK")
            }
        }
        
    }
    
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        // Loading 확인
        isLoadingFollowers = true
        
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            #warning("Dismiss the LoadingView")
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let newFollowers):
                if newFollowers.count < 100 { self.hasMoreFollowers = false }
                self.followers.append(contentsOf: newFollowers)
                
                if self.followers.isEmpty {
                    let message = "해당 유저는 아직 팔로워가 없네요? 팔로우하는건 어떤가요?"
                    DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
                    return
                }
                self.updateData(on: self.followers)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "오류", message: error.rawValue, buttonTitle: "OK")
            }
            self.isLoadingFollowers = false
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseId, for: indexPath) as! FollowerCell
            cell.set(followers: follower)
            return cell
        })
    }
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "뭔가요"
        
        navigationItem.searchController = searchController
    }
}

extension FollowerListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height          = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            // fix in slow connection > users continually requesting for data before the first networkcall is finished or returned
            guard hasMoreFollowers, !isLoadingFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        
        let destinationVC = UserInfoVC()
        
        destinationVC.delegate = self
        destinationVC.username = follower.login
        let navVC = UINavigationController(rootViewController: destinationVC)
        present(navVC, animated: true)
    }
}

extension FollowerListVC: UISearchResultsUpdating {
    
    // fixing Error when removing searchbar text one by one
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            /*
             how is the following code useful? with an empty searchbar state empty?
             >> guard checks if the searchResult is empty.
             As we remove the id one by one, it hits the point where the textfield is blank.
             This is when the following updateData() method is called.
             In order to keep the data clean, remove all the data as well.
             
             + UISearchController already has cancel button activated
             */
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        
        isSearching = true
        filteredFollowers = followers.filter{ $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
}

extension FollowerListVC: FollowerListVCDelegate {
    func didRequestFollower(for username: String) {
        self.username = username
        title = username
        page = 1
        
        followers.removeAll()
        filteredFollowers.removeAll()
        // scrolling screen to the top without giving boilerplate code
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
    }
}
