//
//  ILoginManager.swift
//  API
//
//  Created by setuper on 23.11.2025.
//

import Foundation

public protocol ILoginManager {
    
    var isLoggedIn: Bool { get set }
    var loggedUser: User? { get set }
    func getUser() -> User
}
