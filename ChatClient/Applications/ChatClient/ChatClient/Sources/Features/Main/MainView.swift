//
//  MainVie4w.swift
//  ChatClient
//
//  Created by setuper on 20.09.2025.
//

import SwiftUI
import API
import Services

struct MainView: View {
    @EnvironmentObject var appState: AppState
    @State private var selected: TabIdentifier = .home
    @State private var mateRequest: String = ""
    @State private var displayedMates: [User] = []
    
    var body: some View {
        TabView(selection: $selected) {
            Tab("Main", systemImage: "house", value: .home) {
                GeneralView()
            }
            Tab("Profile", systemImage: "person.crop.circle", value: .profile) {
                ProfileView(user: appState.user)
            }
            Tab(
                "",
                systemImage: "magnifyingglass",
                value: .search,
                role: .search
            ) {
                SearchMateView(
                    user: appState.user,
                    displayedUsers: displayedMates
                )
                .onAppear {
                    UserClient.usersByPreffixCache.removeAllObjects()
                }
                .searchable(text: $mateRequest)
            }
        }
        .onChange(of: mateRequest) { _, userPreffix in
            Task {
                do {
                    displayedMates = try await UserClient.shared.usersByPrefix(from: appState.user.id, prefix: userPreffix)
                } catch {
                    print(error.localizedDescription)
                    print(#file)
                }
            }
        }
    }
}

enum TabIdentifier: Hashable {
    case search
    case home
    case profile
}
