//
//  NetworkManager.swift
//  GhFollowers
//
//  Created by Porori on 2/4/24.
//

import UIKit

protocol NetworkManagerDelegate: AnyObject {
    func didDownloadImage(_ image: UIImage?)
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private let baseURL = "https://api.github.com/users/"
    weak var delegate: NetworkManagerDelegate?
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> Void) {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    // naming Convention Change
        func fetchImage(from urlString: String, with cacheKey: NSString) {
    
            guard let url = URL(string: urlString) else { return }
    
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                if error != nil { return }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
                guard let data = data else { return }
                guard let image = UIImage(data: data) else { return }
    
                // caching the images
                self.cache.setObject(image, forKey: cacheKey)
    
                // download the image, but make sure it's not strongly referenced
                DispatchQueue.main.async {
                    self.delegate?.didDownloadImage(image)
                }
            }
            task.resume()
        }
    
//    func fetchImage(from urlString: String, with cachingKey: NSString, completion: @escaping (Result<UIImage, GFError>) -> Void) {
//        guard let url = URL(string: urlString) else { return }
//        
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(.failure(.invalidData))
//                return
//            }
//            
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completion(.failure(.invalidResponse))
//                return
//            }
//            
//            guard let data = data, let image = UIImage(data: data) else {
//                completion(.failure(.invalidData))
//                return
//            }
//            
//            self.cache.setObject(image, forKey: cachingKey)
//            
//            DispatchQueue.main.async {
//                completion(.success(image))
//            }
//        }
//        task.resume()
//    }
}
