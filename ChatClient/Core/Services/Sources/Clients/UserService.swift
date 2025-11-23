//
//  UserService.swift
//  Services
//
//  Created by setuper on 23.11.2025.
//

import Foundation
import Alamofire
import Network

private struct _UserNamePreffix: Encodable {
    
    let senderId: String
    let prefix: String
    
    enum CodingKeys: String, CodingKey {
        case senderId = "sender_id"
        case prefix = "user_name_prefix"
    }
}

public enum UserClient {
    
    public static func usersByPrefix<T: Decodable>(from id: UUID, prefix: String) async throws -> [T] {
        let request = ApiRequest<_UserNamePreffix>(
            method: .post,
            url: EndPoints_.users.appending("user_name_prefix"),
            body: _UserNamePreffix(senderId: id.uuidString, prefix: prefix)
        )
        let result: ApiResponse<[T]> = try await ApiClient.shared.perform(request: request)
        return result.body
    }
}
