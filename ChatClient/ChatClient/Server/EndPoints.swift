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
    
    var url: URL {
        switch self {
        case .chatUrl:
            return .init(string: "wss://localhost:8443/chat")!
        case .publicKey:
            return .init(string: "\(EndPoints.baseUrl)/publicKey")!
        case .login:
            return .init(string: "\(EndPoints.baseUrl)/login")!
        case let .users(email):
            return .init(string: "\(EndPoints.baseUrl)/users/\(email)")!
        }
    }
    
    static let baseUrl: String = "https://localhost:8443"
}
