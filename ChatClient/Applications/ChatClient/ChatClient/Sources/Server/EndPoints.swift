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
    case users
    case recentChats
    
    var path: String {
        switch self {
        case .chatUrl:
            return "wss://localhost:8443/chat"
        case .publicKey:
            return "/publicKey"
        case .login:
            return "/login"
        case .users:
            return "/users"
        case .recentChats:
            return "/recentChats"
        }
    }
    
    func appending(_ path: String) -> String {
        self.path + "/\(path)"
    }
}
