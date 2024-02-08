//
//  GFAvatarImageView.swift
//  GhFollowers
//
//  Created by Porori on 2/7/24.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    let cache = NetworkManager.shared.cache
    let placeholderImage = UIImage(named: "avatar-placeholder")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(from urlString: String) {
        
        // not handling error - placeholder image IS the error + unable to pop up a viewController on UIImageView
        // check for valid URL
        guard let url = URL(string: urlString) else { return }
        
        // create task to get the image
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
        
            // make sure self is not strongly referenced
            guard let self = self else { return }
            
            // check if there's an error
            if error != nil { return }
            
            // check if response is good
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            
            // check if we have data
            guard let data = data else { return }
            
            // check if the data IS an image data
            guard let image = UIImage(data: data) else { return }
            
            // download the image, but make sure it's not strongly referenced
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }
}
