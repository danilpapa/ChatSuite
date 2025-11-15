//
//  User.swift
//  ChatClient
//
//  Created by setuper on 16.10.2025.
//

import Foundation

struct User: Hashable, Equatable, Identifiable, Decodable {
    
    var id: UUID = .init()
    let email: String
    
    static func anonymous() -> Self {
        .init(email: "anonymous")
    }
}

extension User {
    
    static func danilMaybach() -> User {
        User(
            id: UUID(uuidString: "4f5c7843-4d77-4fea-9426-793963182f9e")!,
            email: "danilmaybach777@gmail.com"
        )
    }
}
