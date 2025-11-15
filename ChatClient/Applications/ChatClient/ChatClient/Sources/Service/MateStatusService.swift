//
//  MateStatusService.swift
//  ChatClient
//
//  Created by setuper on 15.11.2025.
//

import Foundation

protocol IMateStatusService {
    
    func status(mate: User) async -> String
}

struct MateStatusService: IMateStatusService {
    
    func status(mate: User) async -> String {
        do {
            return try await NetworkManager.shared.getMateStatus(for: mate.id)
        } catch {
            print(error.localizedDescription)
            return "Error via accesing mate status"
        }
    }
}
