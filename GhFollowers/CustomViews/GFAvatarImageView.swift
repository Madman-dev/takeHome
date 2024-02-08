//
//  GFAvatarImageView.swift
//  GhFollowers
//
//  Created by Porori on 2/7/24.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    let networkManager = NetworkManager.shared
    let placeholderImage = UIImage(named: "avatar-placeholder")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        networkManager.delegate = self
        
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(from urlString: String) {
        networkManager.downloadImage(from: urlString)   
    }
}

extension GFAvatarImageView: NetworkManagerDelegate {
    func didDownloadImage(_ image: UIImage?) {
        self.image = image
    }
}
