//
//  UserInfoVC.swift
//  GhFollowers
//
//  Created by Porori on 2/15/24.
//

import UIKit

protocol UserInfoVCDelegate: AnyObject {
    func didRequestFollower(for username: String)
}

class UserInfoVC: GFDataLoadingVC {
    
    let scrollview  = UIScrollView()
    let contentView = UIView()
    let headerView  = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel   = GFBodyLabel(textAlignment: .center)
    var itemViews: [UIView] = []
    weak var delegate: UserInfoVCDelegate!
    
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        layoutUI()
        getUserInfo()
    }
    
    private func configureViewController() {
        view.backgroundColor                = .systemBackground
        let doneButton                      = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem   = doneButton
    }
    
    private func getUserInfo() {
        
        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfo(for: username)
                configureUIElementsWithUser(user: user)
            } catch {
                if let gfError = error as? GFError {
                    presentGFAlert(title: "뭔가 잘못됐어요", message: gfError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
            }
        }
    }
    
    private func configureUIElementsWithUser(user: User) {
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: GFRepoItemVC(user: user, delegate: self), to: self.itemViewOne)
        self.add(childVC: GFFollowerItemVC(user: user, delegate: self), to: self.itemViewTwo)
        
        self.dateLabel.text = "Using Github since, \(user.createdAt.convertToMonthYearFormat())"
    }
    
    private func configureScrollView() {
        view.addSubviews(scrollview)
        scrollview.addSubview(contentView)
        scrollview.pinToEdges(superview: view)
        contentView.pinToEdges(superview: scrollview)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollview.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600)
        ])
    }
    
    private func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        
        for itemView in itemViews {
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}

extension UserInfoVC: GFRepoItemVCDelegate {
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            // how is the following function able to run on main Thread? the networkMaanger runs through async await. Not this
            presentGFAlert(title: "URL 오류", message: "URL이 없습니다.", buttonTitle: "Ok")
            return
        }
        presentSafariVC(with: url)
    }
}

extension UserInfoVC: GFFollowerItemVCDelegate {
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
            self.presentGFAlert(title: "No followers", message: "팔로워가 없어요!", buttonTitle: "😭")
            return
        }
        delegate.didRequestFollower(for: user.login)
        dismissVC()
    }
}
