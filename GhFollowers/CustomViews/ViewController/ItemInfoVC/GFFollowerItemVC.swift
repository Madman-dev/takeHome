//
//  GFFollowerItemVC.swift
//  GhFollowers
//
//  Created by Porori on 2/16/24.
//

import UIKit

protocol GFFollowerItemVCDelegate: AnyObject {
    func didTapGetFollowers(for user: User)
}

class GFFollowerItemVC: GFItemInfoVC {
    
    weak var delegate: GFFollowerItemVCDelegate!
    
    init(user: User, delegate: GFFollowerItemVCDelegate) {
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
        firstItemInfoView.set(itemType: .followers, withCount: user.followers)
        secondItemInfoView.set(itemType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .purple, title: "Get Followers")
    }
    
    // makes the request to the Superview
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }
}
