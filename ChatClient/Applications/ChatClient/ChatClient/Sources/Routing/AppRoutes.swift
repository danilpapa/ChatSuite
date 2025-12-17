//
//  AppRoutes.swift
//  ChatClient
//
//  Created by setuper on 30.11.2025.
//

import SwiftUI
import API
import Services

enum AppRoutes: Hashable {
    
    case general
    case search(User, [User])
    case profile(User)
    case chat(WebSocketManager)
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .general:
            GeneralView()
        case .search(let user, let displayedUsers):
            SearchMateView(
                user: user,
                displayedUsers: displayedUsers
            )
        case let .profile(user):
            ProfileView(user: user)
        case let .chat(wsManager):
            ChatView(socketManager: wsManager)
        }
    }
}

