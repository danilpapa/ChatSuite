//
//  File.swift
//  ChatServer
//
//  Created by setuper on 12.10.2025.
//

import Vapor

struct GoogleCredentials: Content {
    
    let email: String
    let firebaseToken: String
}

