//
//  User.swift
//  ChatClient
//
//  Created by setuper on 16.10.2025.
//

import Foundation

struct User: Hashable, Equatable, Identifiable, Decodable {
    
    var id: UUID = .init()
    let email: String
    
    static func anonymous() -> Self {
        .init(email: "anonymous")
    }
}
