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
        let appending = switch self {
        case .chatUrl:
            "wss://localhost:8443/chat"
        case .publicKey:
            "/publicKey"
        case .login:
            "/login"
        case .users:
            "/users"
        case .recentChats:
            "/recentChats"
        }
        return "https://localhost:8443" + appending
    }
    
    func appending(_ path: String) -> String {
        self.path + "/\(path)"
    }
}
