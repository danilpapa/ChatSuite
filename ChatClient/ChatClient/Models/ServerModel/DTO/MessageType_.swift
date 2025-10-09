//
//  MessageType_.swift
//  ChatClient
//
//  Created by setuper on 13.09.2025.
//

import Foundation

enum MessageType: String {
    
    case connectionId = "connection_id"
    case connectedQuantity = "connection_message"
    case chatMessage = "chat_message"
    case clearChat = "clear_chat"
    case publicKeyMessage = "public_key"
}

struct MessageType_: Decodable {
    
    let type: String
}
