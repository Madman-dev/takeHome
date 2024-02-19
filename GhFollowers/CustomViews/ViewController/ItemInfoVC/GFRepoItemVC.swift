//
//  GFRepoItemVC.swift
//  GhFollowers
//
//  Created by Porori on 2/16/24.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        firstItemInfoView.set(itemType: .repos, withCount: user.publicRepos)
        secondItemInfoView.set(itemType: .gist, withCount: user.publicGists)
        actionButton.set(backgroundColor: .green, title: "Github Profile")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(for: user)
    }
}
