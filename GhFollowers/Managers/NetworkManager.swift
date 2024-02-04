//
//  NetworkManager.swift
//  GhFollowers
//
//  Created by Porori on 2/4/24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    let baseURL = "https://api.github.com/users/"
    
    private init() {}
    
    func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, String?) -> Void) {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(nil, "invalid request")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(nil, "unable to finish request")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, "invalid response from server")
                return
            }
            
            guard let data = data else {
                completed(nil, "Data recieved from server was invalid")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(followers, nil)
            } catch {
                completed(nil, "어디가 문제일까")
            }
        }
        
        task.resume()
    }
}
