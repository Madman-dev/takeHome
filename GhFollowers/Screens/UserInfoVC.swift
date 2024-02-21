//
//  UserInfoVC.swift
//  GhFollowers
//
//  Created by Porori on 2/15/24.
//

import UIKit

// Protocol moved from FollowerListVC as UserInfoVC is the VC that needs to request to FollowerListVC search certain followers.
protocol UserInfoVCDelegate: AnyObject {
    func didRequestFollower(for username: String)
}

class UserInfoVC: GFDataLoadingVC {
    
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    var itemViews: [UIView] = []
    weak var delegate: UserInfoVCDelegate!
    
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        
        layoutUI()
        getUserInfo()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                
                DispatchQueue.main.async { self.configureUIElementsWithUser(user: user) }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func configureUIElementsWithUser(user: User) {
        let repoItemVC = GFRepoItemVC(user: user)
        let followerItemVC = GFFollowerItemVC(user: user)
        repoItemVC.delegate = self
        followerItemVC.delegate = self
        
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: repoItemVC, to: self.itemViewOne)
        self.add(childVC: followerItemVC, to: self.itemViewTwo)
        
        self.dateLabel.text = "Using Github since, \(user.createdAt.convertToMonthYearFormat())"
    }
    
    func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}

// UserInfoVC listens to the 2 itemVCs and act correspondingly
extension UserInfoVC: ItemInfoVCDelegate {
    // no need to create delegate as user completes the request by presenting SafariVC
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "URL 오류", message: "URL이 없습니다.", buttonTitle: "Ok")
            return
        }
        presentSafariVC(with: url)
    }
    
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
            self.presentGFAlertOnMainThread(title: "No followers", message: "팔로워가 없어요!", buttonTitle: "😭")
            return
        }
        // UserInfoVC only got the 'tap' signal, needs to complete the request by sending another request to the destination(FollowerListVC)
        delegate.didRequestFollower(for: user.login)
        dismissVC()
    }
}
