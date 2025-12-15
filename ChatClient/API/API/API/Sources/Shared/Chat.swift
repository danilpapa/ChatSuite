//
//  Chat.swift
//  API
//
//  Created by setuper on 15.12.2025.
//

import Foundation

public struct Chat: Identifiable {
    
    public let mate: User
    
    public init(mate: User) {
        self.mate = mate
    }
    
    public var id: String {
        mate.email
    }
}

public struct RecentChat: Decodable {
    
    public var id: UUID
    public var userHost1: User
    public var userHost2: User
    public var updatedAt: Date
    
    public init(id: UUID, userHost1: User, userHost2: User, updatedAt: Date) {
        self.id = id
        self.userHost1 = userHost1
        self.userHost2 = userHost2
        self.updatedAt = updatedAt
    }
}
