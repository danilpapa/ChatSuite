//
//  File.swift
//  ChatServer
//
//  Created by setuper on 15.12.2025.
//

import Fluent

struct RecentChatMigration: AsyncMigration {
    
    func prepare(on database: any Database) async throws {
        try await database.schema(String.RecentChat.schema)
            .id()
            .field(
                String.RecentChat.Fields.userHost1.literal,
                .uuid,
                .required,
                .references(.User.schema, "id")
            )
            .field(
                String.RecentChat.Fields.userHost2.literal,
                .uuid,
                .required,
                .references(.User.schema, "id")
            )
            .field(
                String.RecentChat.Fields.updatedAt.literal,
                .datetime,
                .required
            )
            .unique(on:
                .init(stringLiteral: .RecentChat.Fields.userHost1),
                .init(stringLiteral: .RecentChat.Fields.userHost2)
            )
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(String.RecentChat.schema)
            .delete()
    }
}
