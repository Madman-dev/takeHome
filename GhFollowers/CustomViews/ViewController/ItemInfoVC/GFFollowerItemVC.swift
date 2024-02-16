//
//  GFFollowerItemVC.swift
//  GhFollowers
//
//  Created by Porori on 2/16/24.
//

import UIKit

class GFFollowerItemVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        firstItemInfoView.set(itemType: .followers, withCount: user.followers)
        secondItemInfoView.set(itemType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .purple, title: "Get Followers")
    }
}
