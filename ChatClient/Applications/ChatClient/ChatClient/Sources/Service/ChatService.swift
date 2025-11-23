//
//  ChatService.swift
//  ChatClient
//
//  Created by setuper on 15.11.2025.
//

import Foundation
import Services
import API

protocol IChatService {
    
    func loadRecentChats(for user: User) async -> [Chat]
}

struct ChatService: IChatService {
    
    func loadRecentChats(for user: User) async -> [Chat] {
        do {
            let recentChats: [RecentChat] = try await UserClient.recentChats(for: user.id)
            return recentChats.map {
                let peer = user.email == $0.userHost1.email ? $0.userHost2 : $0.userHost1
                return Chat(mateEmail: peer.email)
            }
        } catch {
            print(#file)
            print(error.localizedDescription)
            return []
        }
    }
}
