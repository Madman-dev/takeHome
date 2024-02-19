//
//  Persistence Manager.swift
//  GhFollowers
//
//  Created by Porori on 2/19/24.
//

import Foundation

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum keys {
        static let favorites = "favorites"
    }
    
    // when using Custom Types of an object, it's saved as Data, thus we need to decode the data
    static func retrieveFavorites(completed: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: keys.favorites) as? Data else {
            // a blank Array, not an error since first time to enter in data
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.failToPersist))
        }
    }
}
