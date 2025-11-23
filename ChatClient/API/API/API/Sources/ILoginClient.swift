//
//  ILoginClient.swift
//  API
//
//  Created by setuper on 23.11.2025.
//

import Foundation

public protocol ILogiClient {
    func login<T: Decodable>(email: String, fbToken: String) async throws -> ApiResponse<T>
}
