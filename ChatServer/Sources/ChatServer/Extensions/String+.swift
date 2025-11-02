//
//  File.swift
//  ChatServer
//
//  Created by setuper on 11.09.2025.
//

import Foundation
import Fluent

public extension String {
    
    static let chatMessage: Self = "chat_message"
    static let connectedQuantity: Self = "connection_message"
    static let clearChat: Self = "clear_chat"
}

extension String {
    
    var literal: FieldKey {
        .init(stringLiteral: self)
    }
}
