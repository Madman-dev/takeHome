//
//  GFError.swift
//  GhFollowers
//
//  Created by Porori on 2/7/24.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername    = "invalid request"
    case unableToComplete   = "unable to finish request"
    case invalidResponse    = "invalid response from server"
    case invalidData        = "Data recieved from server was invalid"
    case failToPersist      = "Unable to Save Data"
    case alreadyInFavorites = "This user is already in the Favorites"
}
