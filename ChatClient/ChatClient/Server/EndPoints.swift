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
    
    var url: URL {
        switch self {
        case .chatUrl:
            return .init(string: "wss://localhost:8443/chat")!
        case .publicKey:
            return .init(string: "https://localhost:8443/publicKey")!
        }
    }
}
