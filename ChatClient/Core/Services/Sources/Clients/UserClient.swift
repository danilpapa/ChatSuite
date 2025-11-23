//
//  UserService.swift
//  Services
//
//  Created by setuper on 23.11.2025.
//

import Foundation
import Alamofire
import Network
import API

private struct _UserNamePreffix: Encodable {
    
    let senderId: String
    let prefix: String
    
    enum CodingKeys: String, CodingKey {
        case senderId = "sender_id"
        case prefix = "user_name_prefix"
    }
}

private struct _UserRecentChats: Encodable {
    
    let userId: String
}

public enum UserClient {
    
    public static func usersByPrefix<T: Decodable>(from id: UUID, prefix: String) async throws -> [T] {
        let request = ApiRequest<_UserNamePreffix>(
            method: .post,
            url: EndPoints.users.appending("user_name_prefix"),
            body: _UserNamePreffix(senderId: id.uuidString, prefix: prefix)
        )
        let result: ApiResponse<[T]> = try await ApiClient.shared.perform(request: request)
        return result.body
    }
    
    public static func recentChats<T: Decodable>(for id: UUID) async throws -> [T] {
        let request = ApiRequest(
            method: .post,
            url: EndPoints.recentChats.path,
            body: _UserRecentChats(userId: id.uuidString)
        )
        let response: ApiResponse<[T]> = try await ApiClient.shared.perform(request: request)
        return response.body
    }
}
