//
//  MateRequestsMigration.swift
//  ChatServer
//
//  Created by setuper on 02.11.2025.
//

import Fluent

struct MateRequestsMigration: AsyncMigration {
    
    func prepare(on database: any Database) async throws {
        try await database.schema(.MateRequests.schema)
            .id()
            .field(String.MateRequests.Fields.from.literal, .string, .required)
            .field(String.MateRequests.Fields.to.literal, .string, .required)
            .field(String.MateRequests.Fields.status.literal, .string, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(String.MateRequests.schema)
            .delete()
    }
}
