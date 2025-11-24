//
//  MainFlow.swift
//  ChatClient
//
//  Created by setuper on 22.11.2025.
//

import SwiftUI
import API

enum MainFlow: Hashable {
    
    case friendRequests(User)
}

extension MainFlow {
    @ViewBuilder
    var body: some View {
        switch self {
        case .friendRequests(let user):
            FriendRequestsView(for: user)
        }
    }
}
