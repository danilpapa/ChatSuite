//
//  IMateClient.swift
//  API
//
//  Created by setuper on 23.11.2025.
//

import Foundation

public protocol IMateClient {
    func getStatus(from id: UUID, to peerId: UUID) async throws -> String
}
