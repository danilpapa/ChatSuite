//
//  User.swift
//  API
//
//  Created by setuper on 23.11.2025.
//

import Foundation

public struct User: Hashable, Equatable, Identifiable, Decodable {
    public init(id: UUID, email: String) {
        self.id = id
        self.email = email
    }
    
    public var id: UUID = .init()
    public let email: String
}

public extension User {
    
    static func danilMaybach() -> User {
        User(
            id: UUID(uuidString: "4f5c7843-4d77-4fea-9426-793963182f9e")!,
            email: "danilmaybach777@gmail.com"
        )
    }
}
