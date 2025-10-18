//
//  File.swift
//  ChatServer
//
//  Created by setuper on 18.10.2025.
//

import Vapor

struct UserId: Content {
    
    let userId: UUID
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}
