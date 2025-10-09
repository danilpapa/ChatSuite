//
//  MessageModel.swift
//  ChatClient
//
//  Created by setuper on 30.09.2025.
//

import Foundation

struct MessageModel: Hashable, Identifiable {
    let id: UUID = .init()
    
    let text: String
    let isYour: Bool
    let sentAt: String
}
