//
//  SwiftUIView.swift
//  ChatServer
//
//  Created by setuper on 25.09.2025.
//

import Fluent
import Vapor

final class User: Model, Content, @unchecked Sendable {
    static let schema = String.User.schema
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: .init(stringLiteral: .User.Fields.email))
    var email: String
    
    @Field(key: .init(stringLiteral: .User.Fields.displayName))
    var displayName: String?
    
    @Field(key: .init(stringLiteral: .User.Fields.firebaseToken))
    var  firebaseToken: String
    
    @Siblings(through: UserFriend.self, from: \.$user, to: \.$friend)
    var friends: [User]
    
    init(
        id: UUID? = nil,
        email: String,
        displayName: String? = nil,
        firebaseToken: String,
        friends: [User] = []
    ) {
        self.id = id
        self.email = email
        self.firebaseToken = firebaseToken
        self.displayName = displayName
    }
    
    init() { }
}

extension String {
    
    enum User {
        
        static let schema = "users"
        
        enum Fields {
            
            static let email = "email"
            static let displayName = "displayName"
            static let firebaseToken = "firebaseToken"
            static let friends = "friends"
        }
    }
}
