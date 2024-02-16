//
//  GFUserInfoHeaderVC.swift
//  GhFollowers
//
//  Created by Porori on 2/16/24.
//

import UIKit

class GFUserInfoHeaderVC: UIViewController {
    // Later try placing the components within a StackView for dynamic
    
    // basic UI components needed within the VC
    let avatarImageView = GFAvatarImageView(frame: .zero)
    let usernameLabel = GFTitleLabel(textAlignment: .left, fontSize: 34)
    let nameLabel = GFSecondaryTitleLabel(size: 18)
    let locationLabel = GFSecondaryTitleLabel(size: 18)
    let locationImageView = UIImageView()
    let bioLabel = GFBodyLabel(textAlignment: .left)
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        layoutUI()
        configureUI()
    }
    
    // when initializing GFHeaderInfoVC, we place in the user and create it.
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        avatarImageView.downloadImage(from: user.avatarUrl)
        usernameLabel.text      = user.login
        nameLabel.text          = user.name ?? "N/A"
        locationLabel.text      = user.location ?? "지역 정보가 없습니다."
        bioLabel.text           = user.bio ?? "자기소개가 비어있습니다."
        bioLabel.numberOfLines  = 3
        
        locationImageView.image = UIImage(systemName: SFSymbols.lcoation)
        locationImageView.tintColor = .secondaryLabel
    }
    
    func addSubview() {
        [avatarImageView, usernameLabel, nameLabel, locationLabel, locationImageView, bioLabel].forEach{ view.addSubview($0) }
    }
    
    func layoutUI() {
        let padding: CGFloat = 20
        let textImagePadding: CGFloat = 12
        
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            // iOS 17에 internationalization 기술로 인해 변경된 부분이 있다. 적용해보자!
            usernameLabel.heightAnchor.constraint(equalToConstant: 38),
            
            // create a stackView to fix the isse
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            locationImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            locationImageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            locationImageView.heightAnchor.constraint(equalToConstant: 20),
            locationImageView.widthAnchor.constraint(equalToConstant: 20),
            
            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 5),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            locationLabel.heightAnchor.constraint(equalToConstant: 20),
            
            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: textImagePadding),
            bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            bioLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
