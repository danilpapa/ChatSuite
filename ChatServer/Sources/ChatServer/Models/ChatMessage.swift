//
//  File.swift
//  ChatServer
//
//  Created by setuper on 11.09.2025.
//

import Vapor

struct ChatMessage: Content {
    
    let type: String = .chatMessage
    let text: String
}
