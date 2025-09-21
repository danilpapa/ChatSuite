//
//  File.swift
//  ChatServer
//
//  Created by setuper on 16.09.2025.
//

import Vapor

struct PublicKeyRequest: Content {
    
    let user_id: String
    let peer_id: String
    let public_key: String
}
