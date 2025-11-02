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
            .field(String.User.Fields.email.literal, .string, .required)
            .field(String.User.Fields.displayName.literal, .string)
            .field(String.User.Fields.firebaseToken.literal, .string, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(String.User.schema)
            .delete()
    }
}
