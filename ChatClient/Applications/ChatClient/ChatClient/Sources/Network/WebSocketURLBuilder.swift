//
//  WebSocketURLBuilder.swift
//  ChatClient
//
//  Created by setuper on 18.10.2025.
//

import Foundation

struct WebSocketURLBuilder {
    
    static let baseURL = URL(string: "wss://localhost:8443")!
    
    static func makeURL(for path: String) -> URL {
        if path.hasPrefix("ws") {
            return URL(string: path)!
        } else {
            return baseURL.appendingPathComponent(path)
        }
    }
}
