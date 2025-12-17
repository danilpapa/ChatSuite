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
    public static let usersByPreffixCache: NSCache<NSString, NSData> = .init()
    
    public func usersByPrefix<T: Codable>(from id: UUID, prefix: String) async throws -> [T] {
        try await Cache.invoke(key: prefix, cache: UserClient.usersByPreffixCache) {
            let request = ApiRequest<_UserNamePreffix>(
                method: .post,
                url: EndPoints.users.appending("user_name_prefix"),
                body: _UserNamePreffix(senderId: id.uuidString, prefix: prefix)
            )
            let result: ApiResponse<[T]> = try await ApiClient.shared.perform(request: request)
            return result.body
        }
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
    
    public func mateStatusAction(
        status: MateStatus,
        from id: UUID,
        to peerId: UUID
    ) async throws {
        guard status != .pending else { return }
        let request = ApiRequest<_FriednRequestAction>(
            method: .post,
            url: EndPoints.friendActionRequests.path,
            query: [
                "action": status.rawValue
            ],
            body: _FriednRequestAction(
                id: id,
                peerId: peerId
            )
        )
        let _: ApiResponse<Never> = try await ApiClient.shared.perform(request: request)
    }
    
    public func activeFriends(for user: User) async throws -> [User] {
        let request = ApiRequest<Never>(
            method: .get,
            url: EndPoints.activeFriends.path,
            query: [
                "user_id": user.id
            ]
        )
        let response: ApiResponse<[User]> = try await ApiClient.shared.perform(request: request)
        return response.body
    }
    
    public func userName(for id: String) async throws -> String {
        let request = ApiRequest<Never>(
            method: .get,
            url: EndPoints.userName.path,
            query: [
                "user_id": id
            ]
        )
        let response: ApiResponse<_UserName> = try await ApiClient.shared.perform(request: request)
        return response.body.name
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

private struct _UserName: Decodable {
    
    var name: String
}
