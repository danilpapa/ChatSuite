//
//  File.swift
//  ChatServer
//
//  Created by setuper on 25.10.2025.
//

import Vapor

struct UserPreffixModel: Content {
    
    var senderId: UUID
    var namePrefix: String
    
    enum CodingKeys: String, CodingKey {
        case senderId = "sender_id"
        case namePrefix = "user_name_prefix"
    }
}
