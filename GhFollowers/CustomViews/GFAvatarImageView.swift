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
    let cache = NetworkManager.shared.cache
    
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
        
        let cacheKey = NSString(string: urlString)
        
        // check for cache
        if let image = cache.object(forKey: cacheKey) {
            self.image = image
            return
        }
        
        networkManager.downloadImage(from: urlString, with: cacheKey)
    }
}

extension GFAvatarImageView: NetworkManagerDelegate {
    func didDownloadImage(_ image: UIImage?) {
        self.image = image
    }
}
