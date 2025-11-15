//
//  UserService.swift
//  ChatClient
//
//  Created by setuper on 15.11.2025.
//

import Foundation

protocol IUserService {
    
    func searchViaPreffix(senderId: UUID, _ preffiex: String) async -> [User]
}

struct UserService: IUserService {
    
    func searchViaPreffix(senderId: UUID, _ preffiex: String) async -> [User] {
        do {
            return try await NetworkManager.shared.obtainUsersByNamePrefix(
                from: senderId,
                email: preffiex
            )
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
