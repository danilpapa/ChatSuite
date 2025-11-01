//
//  ChatMessage.swift
//  ChatClient
//
//  Created by setuper on 13.09.2025.
//

import Foundation

struct Message_: Decodable {
    
    let text: String
    let senderId: String
    let sentAt: Date
    
    enum CodingKeys: String, CodingKey {
        case text
        case senderId = "sender"
        case sentAt
    }
}
