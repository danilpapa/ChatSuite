//
//  Message.swift
//  API
//
//  Created by setuper on 15.12.2025.
//

import Foundation

public struct Message: Hashable, Identifiable {
    public let id: UUID = .init()
    
    public let text: String
    public let isYour: Bool
    public let sentAt: String
    
    public init(text: String, isYour: Bool, sentAt: String) {
        self.text = text
        self.isYour = isYour
        self.sentAt = sentAt
    }
}
