//
//  SwiftUIView.swift
//  ChatServer
//
//  Created by setuper on 25.09.2025.
//

import Fluent
import Vapor

final class User: Model, Content, @unchecked Sendable {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "email")
    var email: String
    
    init(id: UUID? = nil, email: String) {
        self.id = id
        self.email = email
    }
    
    init() { }
}
