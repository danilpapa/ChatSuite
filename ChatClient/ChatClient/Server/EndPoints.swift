//
//  EndPoints.swift
//  ChatClient
//
//  Created by setuper on 13.09.2025.
//

import Foundation

enum EndPoints {
    
    case chatUrl
    case publicKey
    case login
    case users(String)
    case recentChats
    
    var path: String {
        switch self {
        case .chatUrl:
            return "wss://localhost:8443/chat"
        case .publicKey:
            return "/publicKey"
        case .login:
            return "/login"
        case let .users(email):
            return "/users/\(email)"
        case .recentChats:
            return "/recentLobby"
        }
    }
}
