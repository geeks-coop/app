//
//  AuthServiceProtocol.swift
//  Pickr
//
//  Created by  jwkwon0817 on 11/11/24.
//
import Foundation
import Alamofire


protocol AuthServiceProtocol {
    static func login(userId: String, password: String) async throws -> AuthResponse
    static func me() async throws -> MeResponse
    static func signup(userId: String, nickname: String, password: String) async throws -> AuthResponse
}


class AuthService: AuthServiceProtocol {
    static func login(userId: String, password: String) async throws -> AuthResponse {
        let parameters = [
            "user_id": userId,
            "password": password
        ]
        
        return try await APIClient.shared.request("/auth/login", method: .post, parameters: parameters)
    }
    
    static func signup(userId: String, nickname: String, password: String) async throws -> AuthResponse {
        let parameters = [
            "username": nickname,
            "user_id": userId,
            "password": password
        ]
        
        return try await APIClient.shared.request("/auth/register", method: .post, parameters: parameters)
    }
    
    static func me() async throws -> MeResponse {
        return try await APIClient.shared.request("/user/me", authRequired: true)
    }
}
