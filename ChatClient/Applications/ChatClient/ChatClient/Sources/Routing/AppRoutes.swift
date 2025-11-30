//
//  AppRoutes.swift
//  ChatClient
//
//  Created by setuper on 30.11.2025.
//

import SwiftUI
import API

enum AppRoutes: Hashable {
    
    case general(User)
    case search(User, [User])
    case profile(User)
    case friendRequest(User)
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case let .general(user):
            GeneralView(user: user)
        case .search(let user, let displayedUsers):
            SearchMateView(
                user: user,
                displayedUsers: displayedUsers
            )
        case let .profile(user):
            ProfileView(user: user)
        case let .friendRequest(user):
            FriendRequestsView(for: user)
        }
    }
}

