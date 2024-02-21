//
//  Persistence Manager.swift
//  GhFollowers
//
//  Created by Porori on 2/19/24.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(follower: Follower, actionType: PersistenceActionType, completed: @escaping (GFError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            // mutable Array of favorites
            case .success(var favorites):
                
                switch actionType {
                case .add:
                    guard !favorites.contains(follower) else {
                        // 중복 확인
                        completed(.alreadyInFavorites)
                        return
                    }
                    favorites.append(follower)
                
                // remove duplicate users
                case .remove:
                    favorites.removeAll { $0.login == follower.login }
                }
                
                // save after removing duplicate
                completed(save(favorite: favorites))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
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
    
    static func save(favorite: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorite)
            
            defaults.setValue(encodedFavorites, forKey: keys.favorites)
            return nil
        } catch {
            return .failToPersist
        }
    }
}
