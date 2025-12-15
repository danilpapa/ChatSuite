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
    @Published var mateToChat: User?

    init(user: User, mateToChat: User? = nil) {
        self.user = user
        self.mateToChat = mateToChat
    }
}
