//
//  UserService.swift
//  ChatClient
//
//  Created by setuper on 15.11.2025.
//

import Foundation
import Services
import API

protocol IUserService {
    
    func searchViaPreffix(senderId: UUID, _ userPrefix: String) async -> [User]
}

struct UserService: IUserService {
    
    func searchViaPreffix(senderId: UUID, _ userPrefix: String) async -> [User] {
        do {
            return try await UserClient.usersByPrefix(from: senderId, prefix: userPrefix)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
