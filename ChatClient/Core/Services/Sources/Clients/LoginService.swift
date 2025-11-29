//
//  LoginClient.swift
//  HeedAssembly
//
//  Created by setuper on 23.11.2025.
//

import Foundation
import Network
import API
import Singleton

@Singleton
public struct LoginClient {
    
    public func login<_LoginResponse>(email: String, fbToken: String) async throws -> ApiResponse<_LoginResponse> {
        let apiRequest = ApiRequest<_LoginUser>(
            method: .post,
            url: EndPoints.login.path,
            body: _LoginUser(email: email, firebaseToken: fbToken)
        )
        return try await ApiClient.shared.perform(request: apiRequest)
    }
}

private struct _LoginUser: Codable {
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
