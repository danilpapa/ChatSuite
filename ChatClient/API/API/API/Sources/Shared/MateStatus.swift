//
//  MateStatus.swift
//  API
//
//  Created by setuper on 08.12.2025.
//

import Foundation

public enum MateStatus: String, Decodable {
    
    case addMate
    case pending
    case acceptDelete
    case deleteMate
    
    var title: String {
        switch self {
        case .addMate: return "Add mate"
        case .pending: return "Pending"
        case .acceptDelete: return "Accept/Delete"
        case .deleteMate: return "Delete mate"
        }
    }
}
