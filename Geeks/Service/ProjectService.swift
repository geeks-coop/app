//
//  AuthServiceProtocol.swift
//  Pickr
//
//  Created by  jwkwon0817 on 11/11/24.
//
import SwiftUI
import Alamofire

struct ProjectListResponse: Codable {
    let status: String
    let projects: [ProjectResponse]
}

struct ProjectOneResponse: Codable {
    let status: String
    let project: ProjectResponse
}

struct ProjectResponse: Codable, Identifiable {
    let id: String
    let name: String
    let shortDescription: String
    let description: String
    let tags: [String]
    let images: [ImageModel]
    let createdAt: String
    let createdBy: String
    let createdByProfile: Int

    enum CodingKeys: String, CodingKey {
        case id = "project_id"
        case name = "project_name"
        case shortDescription = "project_short_description"
        case description = "project_description"
        case tags = "project_tags"
        case images = "project_images"
        case createdAt = "project_created_at"
        case createdBy = "project_created_by_name"
        case createdByProfile = "project_created_by_profile"
    }
}

struct ImageModel: Codable, Identifiable {
    let id: Int?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "image_id"
        case url
    }
    
    // 빈 객체도 처리할 수 있도록 기본 생성자 추가
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        id = try? container?.decode(Int.self, forKey: .id)
        url = try? container?.decode(String.self, forKey: .url)
    }
}

struct ImageResponse: Codable {
   let status: String
   let imageUrl: String
   
   enum CodingKeys: String, CodingKey {
       case status
       case imageUrl = "image_url"
   }
}

struct ProjectCreateResponse: Codable {
   let status: String
   let projectId: String
   
   enum CodingKeys: String, CodingKey {
       case status
       case projectId = "project_id"
   }
}

struct FollowResponse: Codable {
   let status: String
}

protocol ProjectServiceProtocol {
    static func getList(limit: Int) async throws -> ProjectListResponse
    
    static func search(keyword: String) async throws -> ProjectListResponse
    
    static func create(name: String, shortDescription: String, description: String, tags: [String], images: [String]) async throws -> ProjectCreateResponse
    
    static func uploadImage(image: UIImage) async throws -> ImageResponse
    static func heartProject(projectId: String) async throws -> Bool
    static func getHeartUsers(projectId: String) async throws -> [String]
}


class ProjectService: ProjectServiceProtocol {
    static func getList(limit: Int) async throws -> ProjectListResponse {
        
        return try await APIClient.shared.request("/project/list?limit=\(limit)", authRequired: true)
    }
    
    static func get(id: String) async throws -> ProjectOneResponse {
        return try await APIClient.shared.request("/project/g/\(id)", authRequired: true)
    }
    
    static func search(keyword: String) async throws -> ProjectListResponse {
        return try await APIClient.shared.request("/project/search?keyword=\(keyword)", authRequired: true)
    }
    
    static func create(name: String, shortDescription: String, description: String, tags: [String], images: [String]) async throws -> ProjectCreateResponse {
        
        let imageObjects = images.enumerated().map { index, image in
            return ["image_id": index + 1, "url": image]
        }
        
        let parameters: [String: Any] = [
            "project_name": name,
            "project_short_description": shortDescription,
            "project_description": description,
            "project_tags": tags,
            "project_images": imageObjects
        ]
        
        return try await APIClient.shared.request(
            "/project/create",
            method: .post,
            parameters: parameters,
            authRequired: true
        )
    }
    
    static func uploadImage(image: UIImage) async throws -> ImageResponse {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw APIError.imageConversionFailed
        }
        
        let base64String = imageData.base64EncodedString()
        
        let parameters: [String: Any] = [
            "images": base64String
        ]

        return try await APIClient.shared.request("/file/upload",
                                                    method: .post,
                                                    parameters: parameters,
                                                    authRequired: true)
    }

    
    static func heartProject(projectId: String) async throws -> Bool {
        try await APIClient.shared.request("/follow/project/\(projectId)/follow",
                                           method: .post,
                                           authRequired: true)
    }
    
    static func getHeartUsers(projectId: String) async throws -> [String] {
        return try await APIClient.shared.request("/follow/project/\(projectId)/followed",
                                                  method: .get,
                                                  authRequired: true) 
    } 
}

enum APIError: Error {
    case imageConversionFailed
    case uploadFailed
}
