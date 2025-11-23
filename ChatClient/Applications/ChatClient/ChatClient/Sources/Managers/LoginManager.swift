//
//  LoginManager.swift
//  ChatClient
//
//  Created by setuper on 24.11.2025.
//

import Foundation
import API

@Observable
public final class LoginManager: ILoginManager {
    public init(
        isLoggedIn: Bool = false,
        loggedUser: User? = nil
    ) {
        self.isLoggedIn = isLoggedIn
        self.loggedUser = loggedUser
    }
    
    public var isLoggedIn: Bool
    public var loggedUser: User?
    
    public func getUser() -> User {
        guard let loggedUser else {
            fatalError("Error accesing with no authorization")
        }
        return loggedUser
    }
}
