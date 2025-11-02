//
//  RecentChats.swift
//  ChatServer
//
//  Created by setuper on 16.10.2025.
//

import Foundation
import Fluent
import Vapor

final class RecentChats: Model, @unchecked Sendable, Content {
    static let schema = String.RecentChat.schema
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: String.RecentChat.Fields.userHost1.literal)
    var userHost1: User
    
    @Parent(key: String.RecentChat.Fields.userHost2.literal)
    var userHost2: User
    
    @Field(key: String.RecentChat.Fields.updatedAt.literal)
    var updatedAt: Date
    
    init() {}
    
    init(
        id: UUID? = nil,
        userHost1ID: UUID,
        userHost2ID: UUID,
        updatedAt: Date
    ) {
        self.id = id
        self.$userHost1.id = userHost1ID
        self.$userHost2.id = userHost2ID
        self.updatedAt = updatedAt
    }
}

extension String {
    
    enum RecentChat {
        
        static let schema = "recentChats"
        
        enum Fields {
            
            static let userHost1 = "userHost1"
            static let userHost2 = "userHost2"
            static let updatedAt = "updatedAt"
        }
    }
}
