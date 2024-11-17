//
//  AuthModel.swift
//  Geeks
//
//  Created by  jwkwon0817 on 11/15/24.
//

struct AuthResponse: Decodable {
    let status: String
    let accessToken: String
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}

struct MeResponse: Decodable {
    let status: String
    let username: String
    let userId: String
    let profile: Int
    let description: String
    let projects: [String]
    let follwingUsers: [String]
    let likedProjects: [String]
    
    enum CodingKeys: String, CodingKey {
        case status
        case username
        case userId = "user_id"
        case profile
        case description
        case projects = "my_projects"
        case followingUsers = "following_users"
        case likedProjects = "following_projects"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(String.self, forKey: .status)
        username = try container.decode(String.self, forKey: .username)
        userId = try container.decode(String.self, forKey: .userId)
        profile = try container.decode(Int.self, forKey: .profile)
        description = try container.decode(String.self, forKey: .description)
        projects = try container.decode([String].self, forKey: .projects)
        follwingUsers = try container.decode([String].self, forKey: .followingUsers)
        likedProjects = try container.decode([String].self, forKey: .likedProjects)
    }
}
