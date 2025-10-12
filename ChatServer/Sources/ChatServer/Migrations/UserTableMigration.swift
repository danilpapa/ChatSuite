//
//  SwiftUIView.swift
//  ChatServer
//
//  Created by setuper on 25.09.2025.
//

import Fluent

struct UserTableMigration: AsyncMigration {
    
    func prepare(on database: any Database) async throws {
        try await database.schema(String.User.schema)
            .id()
            .field(.init(stringLiteral: .User.Fields.email), .string, .required)
            .field(.init(stringLiteral: .User.Fields.displayName), .string)
            .field(.init(stringLiteral: .User.Fields.firebaseToken), .string, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(String.User.schema)
            .delete()
    }
}
