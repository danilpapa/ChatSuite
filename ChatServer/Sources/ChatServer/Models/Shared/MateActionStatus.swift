//
//  MateActionStatus.swift
//  ChatServer
//
//  Created by setuper on 08.12.2025.
//

import Foundation

enum MateActionStatus: String, Codable, Sendable {
    
    case addMate = "Add mate"
    case pending = "Pending"
    case acceptDelete = "Accept/Delete mate"
    case deleteMate = "Delete mate"
}
