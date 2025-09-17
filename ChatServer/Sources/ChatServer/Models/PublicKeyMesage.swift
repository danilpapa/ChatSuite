//
//  File.swift
//  ChatServer
//
//  Created by setuper on 17.09.2025.
//

import Vapor

struct PublicKeyMesage: Content {
    
    let type: String = "public_key"
    let key: Data
}
