//
//  Endpoints.swift
//  HeedAssembly
//
//  Created by setuper on 23.11.2025.
//

import Foundation

public enum EndPoints_ {
    
    case chatUrl
    case publicKey
    case login
    case users
    case recentChats
    
    public var path: String {
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
    
    public func appending(_ path: String) -> String {
        self.path + "/\(path)"
    }
}
