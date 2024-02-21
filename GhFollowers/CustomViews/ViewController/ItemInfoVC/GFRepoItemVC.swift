//
//  GFRepoItemVC.swift
//  GhFollowers
//
//  Created by Porori on 2/16/24.
//

import UIKit

protocol GFRepoItemVCDelegate: AnyObject {
    func didTapGitHubProfile(for user: User)
}


class GFRepoItemVC: GFItemInfoVC {
    
    weak var delegate: GFRepoItemVCDelegate!
    
    init(user: User, delegate: GFRepoItemVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        firstItemInfoView.set(itemType: .repos, withCount: user.publicRepos)
        secondItemInfoView.set(itemType: .gist, withCount: user.publicGists)
        actionButton.set(backgroundColor: .blue, title: "Github Profile")
    }
    
    // makes the request to the Superview
    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(for: user)
    }
}
