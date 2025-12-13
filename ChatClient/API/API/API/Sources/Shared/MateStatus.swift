//
//  MateStatus.swift
//  API
//
//  Created by setuper on 08.12.2025.
//

import Foundation

public enum MateStatus: String, Decodable, Identifiable {
    
    case addMate
    case pending
    case acceptDelete
    case deleteMate
    case noAvailableStatus
    
    public var title: String {
        switch self {
        case .addMate: return "Add mate"
        case .pending: return "Pending"
        case .acceptDelete: return "Accept/Delete"
        case .deleteMate: return "Delete mate"
        case .noAvailableStatus: return "Status is loading"
        }
    }
    
    public var id: Self {
        self
    }
}
