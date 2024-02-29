//
//  FollowerListVC.swift
//  GhFollowers
//
//  Created by Porori on 2/4/24.
//

import UIKit

class FollowerListVC: GFDataLoadingVC {
    
    enum Section { case main }
    
    var username: String!
    var followers: [Follower]           = []
    var filteredFollowers: [Follower]   = []
    var page: Int                       = 1
    var hasMoreFollowers: Bool          = true
    var isSearching: Bool               = false
    var isLoadingMoreFollowers: Bool        = false
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username   = username
        title           = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // default empty view State
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        if followers.isEmpty && !isLoadingMoreFollowers {
            var config = UIContentUnavailableConfiguration.empty()
            config.image = .init(systemName: "person")
            config.text = "팔로워가 없습니다."
            config.secondaryText = "😭"
            contentUnavailableConfiguration = config
        } else if isSearching && filteredFollowers.isEmpty {
            // searchbar에서 겁색할 경우
            contentUnavailableConfiguration = UIContentUnavailableConfiguration.search()
            
        } else {
            contentUnavailableConfiguration = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureSearchController()
        getFollowers(username: username, page: page)
        configureDataSource()
    }

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds,
                                          collectionViewLayout: UIHelper.createThreeColumnFlowlayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate         = self
        collectionView.backgroundColor  = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseId)
    }
    
    
    /*
     ** structured vs unstructure concurrency
     - Unstructured
     As I know, completion blocks return with data even after the function dies.
     This creates unstructured concurrency as when the function is first called -> it initiates the network call and leaves the function -> when the data is collected, the data returns to the function and initates the rest of it. Making it unstructured (in terms of call)
     
     - Structured
     everything goes in order
     */
    
    private func getFollowers(username: String, page: Int) { // Following code 'async' call in a function that does not support concurrency
        showLoadingView()
        isLoadingMoreFollowers = true
        
        // MARK: - Initial Completion Handler implemented method
        //        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
        //            guard let self = self else { return }
        //            #warning("loading view가 아직 돌아가고 있어요")
        //            self.dismissLoadingView()
        //
        //            switch result {
        //            case .success(let newFollowers):
        //                self.updateUI(with: newFollowers)
        //
        //            case .failure(let error):
        //                self.presentGFAlertOnMainThread(title: "오류", message: error.rawValue, buttonTitle: "OK")
        //            }
        //            self.isLoadingMoreFollowers = false
        //        }
        
        
        // MARK: - async await, concurrently
        Task { // concurrency context
        
        // MARK: - Handling each error distinctively
            do {
                let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
//                let followers: [Follower] = [] > testing code
                updateUI(with: followers)
                dismissLoadingView()
            } catch {
                if let gfError = error as? GFError {
                    presentGFAlert(title: "Error 발생", message: gfError.rawValue, buttonTitle: "OK")
                } else {
                    // catching Every other error other than GFError
                    presentDefaultError()
                }
                dismissLoadingView()
            }
            
        // MARK: - Handling error overall - Generically
//            guard let followers = try? await NetworkManager.shared.getFollowers(for: username, page: page) else {
//                presentDefaultError()
//                dismissLoadingView()
//                return
//            }
//            updateUI(with: followers)
//            dismissLoadingView()
        }
    }
    
    private func updateUI(with followers: [Follower]) {
        if followers.count < 100 { self.hasMoreFollowers = false }
        self.followers.append(contentsOf: followers)
        self.updateData(on: self.followers)
        setNeedsUpdateContentUnavailableConfiguration()
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseId, for: indexPath) as! FollowerCell
            cell.set(followers: follower)
            
            return cell
        })
    }
    
    private func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "뭔가요"
        
        navigationItem.searchController = searchController
    }
    
    @objc func addButtonTapped() {
        showLoadingView()
        
        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfo(for: username)
                addUserToFavorites(user: user)
                dismissLoadingView()
            } catch {
                if let gfError = error as? GFError {
                    presentGFAlert(title: "뭔가 잘못됐습니다.", message: gfError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
                dismissLoadingView()
            }
        }
    }
    
    private func addUserToFavorites(user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        
        PersistenceManager.updateWith(follower: favorite, actionType: .add) { [weak self] error in
            guard let self else { return }
            
            // Swift 5.7 update > no more need to guard let error = error
            guard let error else {
                DispatchQueue.main.async {
                    self.presentGFAlert(title: "성공!", message: "저장되었습니다.", buttonTitle: "Ok")
                }
                return
            }
            DispatchQueue.main.async {
                self.presentGFAlert(title: "뭔가 잘못됐어요", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}

extension FollowerListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height          = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            // fix in slow connection > users continually requesting for data before the first networkcall is finished or returned
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray     = isSearching ? filteredFollowers : followers
        let follower        = activeArray[indexPath.item]
        let destinationVC   = UserInfoVC()
        
        destinationVC.delegate  = self
        destinationVC.username  = follower.login
        let navVC               = UINavigationController(rootViewController: destinationVC)
        present(navVC, animated: true)
    }
}

extension FollowerListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        
        isSearching         = true
        filteredFollowers   = followers.filter{ $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
        // Since I need to show the users that the data isn't available AFTER updating the followers.
        setNeedsUpdateContentUnavailableConfiguration()
    }
}

extension FollowerListVC: UserInfoVCDelegate {
    func didRequestFollower(for username: String) {
        self.username   = username
        title           = username
        page            = 1
        
        followers.removeAll()
        filteredFollowers.removeAll()
        
        // when tapping followers, without scroll, VC title blocks avatar image
        // collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true) > unable to fix
        collectionView.scrollToItem(at: IndexPath(row: -1, section: 0), at: .top, animated: true) // potential fix
        getFollowers(username: username, page: page)
    }
}

#Preview {
    FollowerListVC(username: "madman-dev")
}
