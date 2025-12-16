//
//  AppState.swift
//  ChatClient
//
//  Created by setuper on 15.12.2025.
//

import Foundation
import API

final class AppState: ObservableObject {
    
    @Published var user: User
    
    public init(user: User) {
        self.user = user
    }
}
