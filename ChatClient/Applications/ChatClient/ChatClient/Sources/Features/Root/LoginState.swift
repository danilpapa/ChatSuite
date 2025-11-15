//
//  LoginState.swift
//  ChatClient
//
//  Created by setuper on 15.11.2025.
//

import Foundation

final class LoginState: ObservableObject {
    
    @Published var isLoggedIn = false
    var loggedUser: User?
}
