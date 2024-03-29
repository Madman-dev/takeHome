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
    enum keys { static let favorites = "favorites" }
    
    static func updateWith(follower: Follower, actionType: PersistenceActionType, completed: @escaping (GFError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):
                
                switch actionType {
                case .add:
                    guard !favorites.contains(follower) else {
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
    
//    static func updateWith(follower: Follower, actionType: PersistenceActionType) async throws -> GFError {
//        retrieveFavorites()
//    }
 
    
    // why change the initial @escaping to async throws?? > no need use completion handlers
//    static func retrieveFavorites() async throws -> [Follower] {
//        guard let favoriteData = defaults.object(forKey: keys.favorites) as? Data else { return [] }
//        
//        do {
//            let decoder = JSONDecoder()
//            let favorite = try decoder.decode([Follower].self, from: favoriteData)
//            return favorite
//        } catch {
//            throw GFError.failToPersist
//        }
//    }
    
    
    static func retrieveFavorites(completed: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: keys.favorites) as? Data else {
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
