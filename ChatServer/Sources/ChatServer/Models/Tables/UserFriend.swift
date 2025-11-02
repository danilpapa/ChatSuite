//
//  File.swift
//  ChatServer
//
//  Created by setuper on 12.10.2025.
//

import Fluent

final class UserFriend: Model, @unchecked Sendable {
    static let schema = String.UserFriends.schema
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: String.UserFriends.Fields.userId.literal)
    var user: User
    
    @Parent(key: String.UserFriends.Fields.friendId.literal)
    var friend: User
    
    init() {}
    
    init(
        id: UUID? = nil,
        userID: UUID,
        friendID: UUID
    ) {
        self.id = id
        self.$user.id = userID
        self.$friend.id = friendID
    }
}

extension String {
    
    enum UserFriends {
        
        static let schema = "userFriends"
        
        enum Fields {
            
            static let userId = "userId"
            static let friendId = "friendId"
        }
    }
}
