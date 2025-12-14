//
//  MateStatus.swift
//  API
//
//  Created by setuper on 08.12.2025.
//

import Foundation
import SwiftUI

public enum MateStatus: String, Decodable, Identifiable {
    
    case addMate
    case pending
    case acceptDiscard
    case deleteMate
    
    public var title: String {
        switch self {
        case .addMate: return "Add mate"
        case .pending: return "Pending"
        case .acceptDiscard: return "Accept/Discard"
        case .deleteMate: return "Delete mate"
        }
    }
    
    public var tint: Color {
        switch self {
        case .addMate:
            return .green
        case .pending:
            return .blue
        case .deleteMate:
            return .red
        default: return .clear
        }
    }
    
    public var id: Self {
        self
    }
}
