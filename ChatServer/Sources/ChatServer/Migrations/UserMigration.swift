//
//  SwiftUIView.swift
//  ChatServer
//
//  Created by setuper on 25.09.2025.
//

import Fluent

struct UserMigration: AsyncMigration {
    
    func prepare(on database: any Database) async throws {
        try await database.schema("users")
            .id()
            .field("email", .string, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("users")
            .delete()
    }
}
