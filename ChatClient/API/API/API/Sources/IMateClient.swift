//
//  IMateClient.swift
//  API
//
//  Created by setuper on 23.11.2025.
//

import Foundation

public protocol IMateClient {
    func getStatus(for id: UUID) async throws -> String
}
