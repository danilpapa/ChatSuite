//
//  File.swift
//  ChatServer
//
//  Created by setuper on 11.09.2025.
//

import Vapor

struct ConnectionMessage: Content {
    
    let type: String = .connectedQuantity
    let count: Int
}
