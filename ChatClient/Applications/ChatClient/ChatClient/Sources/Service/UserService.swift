//
//  UserService.swift
//  ChatClient
//
//  Created by setuper on 15.11.2025.
//

import Foundation

protocol IUserService {
    
    func searchViaPreffix(_ preffiex: String) async -> [User]
}

struct UserService: IUserService {
    
    func searchViaPreffix(_ preffiex: String) async -> [User] {
        do {
            return try await NetworkManager.shared.obtainUsersByNamePrefix(email: preffiex)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
