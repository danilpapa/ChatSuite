//
//  ProfileView.swift
//  ChatClient
//
//  Created by setuper on 30.11.2025.
//

import SwiftUI
import API

struct ProfileView: View {
    @StateObject private var router = Router()
    @State private var selectedAction: ProfileAction?
    
    var user: User
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack {
                List {
                    ForEach(ProfileAction.allCases, id: \.self) { profileAction in
                        Button(ProfileAction.friendList.rawValue) {
                            selectedAction = profileAction
                        }
                    }
                }
            }
            .sheet(item: $selectedAction) { action in
                switch action {
                case .friendList:
                    ActiveFriendsView(user: user)
                }
            }
            .navigationDestination(for: AppRoutes.self) { $0.destination }
            .navigationTitle("\(user.email)")
        }
    }
}

enum ProfileAction: String, Hashable, CaseIterable, Identifiable {
    
    case friendList = "Friends"
    
    var id: String {
        self.rawValue
    }
}
