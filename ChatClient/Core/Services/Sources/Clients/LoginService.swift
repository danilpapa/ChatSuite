//
//  LoginClient.swift
//  HeedAssembly
//
//  Created by setuper on 23.11.2025.
//

import Foundation
import Network

private struct _LoginUser: Encodable {
    let email: String
    let firebaseToken: String
    
    enum CodingKeys: String, CodingKey {
        case email = "user_email"
        case firebaseToken = "firebase_token"
    }
}

public struct _LoginResponse: Decodable {
    
    public let id: UUID
}

public enum LoginClient {
    
    public static func login(email: String, fbToken: String) async throws -> ApiResponse<_LoginResponse> {
        let apiRequest = ApiRequest<_LoginUser>(
            method: .post,
            url: EndPoints_.login.path,
            body: _LoginUser(email: email, firebaseToken: fbToken)
        )
        return try await ApiClient.shared.perform(request: apiRequest)
    }
}
