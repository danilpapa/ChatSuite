//
//  File.swift
//  ChatServer
//
//  Created by setuper on 12.10.2025.
//

import Fluent

struct UserFriendsMigration: AsyncMigration {
    
    func prepare(on database: any Database) async throws {
        try await database.schema(.UserFriends.schema)
            .id()
            .field(
                .init(stringLiteral: .UserFriends.Fields.userId),
                .uuid, .required,
                .references(.User.schema, "id")
            )
            .field(
                .init(stringLiteral: .UserFriends.Fields.friendId),
                .uuid, .required,
                .references(.User.schema, "id")
            )
            .unique(on:
                    .init(stringLiteral: .UserFriends.Fields.userId),
                    .init(stringLiteral: .UserFriends.Fields.friendId))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(.UserFriends.schema)
            .delete()
    }
}
