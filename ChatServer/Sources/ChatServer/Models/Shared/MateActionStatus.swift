//
//  MateActionStatus.swift
//  ChatServer
//
//  Created by setuper on 08.12.2025.
//

import Foundation

enum MateActionStatus: String, Codable {
    
    case addMate
    case pending
    case accept
    case discard
    case deleteMate
    case expectation
}
