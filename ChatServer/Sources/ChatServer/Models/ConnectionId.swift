//
//  File.swift
//  ChatServer
//
//  Created by setuper on 16.09.2025.
//

import Vapor

struct ConnectionId: Content {
    
    let type: String = "connection_id"
    let id: UUID
}
