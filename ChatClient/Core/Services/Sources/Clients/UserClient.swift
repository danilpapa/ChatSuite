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
import Singleton

@Singleton
public struct UserClient {
    
    public func usersByPrefix<T: Decodable>(from id: UUID, prefix: String) async throws -> [T] {
        let request = ApiRequest<_UserNamePreffix>(
            method: .post,
            url: EndPoints.users.appending("user_name_prefix"),
            body: _UserNamePreffix(senderId: id.uuidString, prefix: prefix)
        )
        let result: ApiResponse<[T]> = try await ApiClient.shared.perform(request: request)
        return result.body
    }
    
    public func recentChats<T: Decodable>(for id: UUID) async throws -> [T] {
        let request = ApiRequest(
            method: .post,
            url: EndPoints.recentChats.path,
            body: _UserRecentChats(userId: id.uuidString)
        )
        let response: ApiResponse<[T]> = try await ApiClient.shared.perform(request: request)
        return response.body
    }
    
    public func actualFriendRequests(for user: User) async throws -> [User] {
        let request = ApiRequest<Never>(
            method: .get,
            url: EndPoints.friendRequests.path,
            query: [
                "user_id": user.id
            ]
        )
        let respose: ApiResponse<[User]> = try await ApiClient.shared.perform(request: request)
        return respose.body
    }
    
    public func friendRequestAction(_ action: String, from id: UUID, to peerId: UUID) async throws {
        let request = ApiRequest<_FriednRequestAction>(
            method: .post,
            url: EndPoints.friendActionRequests.path,
            query: ["action": action],
            body: _FriednRequestAction(id: id, peerId: peerId)
        )
        let _: ApiResponse<Never> = try await ApiClient.shared.perform(request: request)
    }
}

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

private struct _FriednRequestAction: Encodable {
    
    var id: UUID
    var peerId: UUID
    
    enum CodingKeys: String, CodingKey {
        
        case id = "user_id"
        case peerId = "peer_id"
    }
}
