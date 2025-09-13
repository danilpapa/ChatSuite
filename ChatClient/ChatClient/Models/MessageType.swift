//
//  MessageType.swift
//  ChatClient
//
//  Created by setuper on 13.09.2025.
//

import Foundation

enum MessageType: String {
    
    case connectedQuantity = "connection_message"
    case chatMessage = "chat_message"
    case clearChat = "clear_chat"
}

struct ServerMessagesType: Decodable {
    
    let type: String
}
