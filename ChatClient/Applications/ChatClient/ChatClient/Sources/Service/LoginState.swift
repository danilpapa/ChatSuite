//
//  LoginState.swift
//  ChatClient
//
//  Created by setuper on 15.11.2025.
//

import Foundation

final class LoginState: ObservableObject {
    
    @Published var isLoggedIn = true
    var loggedUser: User? = .danilMaybach()
    
    func getUser() -> User {
        guard let loggedUser else {
            fatalError("Error accesing with no authorization")
        }
        return loggedUser
    }
}
