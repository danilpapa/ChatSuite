//
//  File.swift
//  ChatServer
//
//  Created by setuper on 25.10.2025.
//

import Vapor

struct UserNamePrefixModel: Content {
    
    var namePrefix: String
    
    enum CodingKeys: String, CodingKey {
        case namePrefix = "user_name_prefix"
    }
}
