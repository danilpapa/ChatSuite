//
//  ChatMessage.swift
//  ChatClient
//
//  Created by setuper on 13.09.2025.
//

import Foundation

public struct Message_: Decodable {
    
    public let text: String
    public let senderId: String
    public let sentAt: Date
    
    public init(
        text: String,
        senderId: String,
        sentAt: Date
    ) {
        self.text = text
        self.senderId = senderId
        self.sentAt = sentAt
    }
    
    enum CodingKeys: String, CodingKey {
        case text
        case senderId = "sender"
        case sentAt
    }
}
