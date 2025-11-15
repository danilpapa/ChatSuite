//
//  LoginState.swift
//  ChatClient
//
//  Created by setuper on 15.11.2025.
//

import Foundation

final class LoginState: ObservableObject {
    
    @Published var isLoggedIn = true
    var loggedUser: User? = User(
        id: UUID(uuidString: "4f5c7843-4d77-4fea-9426-793963182f9e")!,
        email: "danilmaybach777@gmail.com"
    )
    
    func getUser() -> User {
        guard let loggedUser else {
            fatalError("Error accesing with no authorization")
        }
        return loggedUser
    }
}
