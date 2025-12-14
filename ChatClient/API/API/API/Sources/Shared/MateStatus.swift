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
    case accept
    case discard
    case deleteMate
    case expectation
    
    public var title: String {
        switch self {
        case .addMate: return "Add mate"
        case .pending: return "Pending"
        case .accept: return "Accept"
        case .discard: return "Discerd"
        case .deleteMate: return "Delete mate"
        case .expectation: return ""
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
        case .accept:
            return .green
        case .discard:
            return .red
        case .expectation: return .clear
        }
    }
    
    public var id: Self {
        self
    }
}
