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
    @EnvironmentObject var router: Router
    @State private var selected: TabIdentifier = .home
    @State private var mateRequest: String = ""
    @State private var displayedMates: [User] = []
    
    var user: User
    
    var body: some View {
        TabView(selection: $selected) {
            Tab("Main", systemImage: "house", value: .home) {
                NavigationStack(path: $router.path) {
                    Text("Main page")
                        .toolbar {
                            ToolbarItem(placement: .primaryAction) {
                                Button {
                                    router.push(MainFlow.friendRequests(user))
                                } label: {
                                    Image(systemName: "person.checkmark.and.xmark")
                                        .foregroundStyle(.blue)
                                        .badge(2)
                                }
                                .buttonStyle(.glass)
                            }
                        }
                        .navigationDestination(for: MainFlow.self) { $0.body }
                }
            }
            
            Tab("Profile", systemImage: "person.crop.circle", value: .profile) {
                NavigationStack(path: $router.path) {
                    ProfileView(user: user)
                }
            }
            
            Tab(
                "",
                systemImage: "magnifyingglass",
                value: .search,
                role: .search
            ) {
                NavigationStack(path: $router.path) {
                    SearchMateView(user: user, displayedUsers: displayedMates)
                        .searchable(text: $mateRequest)
                }
            }
        }
        .onChange(of: mateRequest) { _, userPreffix in
            Task {
                do {
                    displayedMates = try await UserClient.shared.usersByPrefix(from: user.id, prefix: userPreffix)
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

#Preview {
    ChatClient(router: Router())
}
