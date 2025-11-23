//
//  MainFlow.swift
//  ChatClient
//
//  Created by setuper on 22.11.2025.
//

import SwiftUI

enum MainFlow: Hashable {
    
    case mateStatusPage(User)
    case friendRequests(User)
}

extension MainFlow {
    @ViewBuilder
    var body: some View {
        switch self {
        case .friendRequests(let user):
            Text("Add")
        case .mateStatusPage(let mate):
            MateStatusPageView(mate: mate)
        }
    }
}
