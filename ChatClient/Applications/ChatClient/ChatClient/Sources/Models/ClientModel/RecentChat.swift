//
//  RecentChat.swift
//  ChatClient
//
//  Created by setuper on 19.10.2025.
//

import Foundation
import API

struct RecentChat: Decodable {
    
    var id: UUID
    var userHost1: User
    var userHost2: User
    var updatedAt: Date
}
