//
//  User.swift
//  GhFollowers
//
//  Created by Porori on 2/4/24.
//

import Foundation

// out app is only able to pull down the data on the web
struct User: Codable {
    let login: String
    let avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let following: Int
    let followers: Int
    let createdAt: String
}
