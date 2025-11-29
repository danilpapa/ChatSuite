//
//  MainVie4w.swift
//  ChatClient
//
//  Created by setuper on 20.09.2025.
//

import SwiftUI
import API
import Services

enum TabIdentifier: Hashable {
    case search,
         home
}

struct MainView: View {
    @EnvironmentObject var router: Router
    @State private var selected: TabIdentifier = .home
    @State private var mateRequest: String = ""
    @State private var displayedMates: [User] = []
    @State private var friendRequestBadges: Int = 0
    
    var user: User
    var userService: IUserService
    var mateClient: IMateClient
    
    var body: some View {
        TabView(selection: $selected) {
            Tab(
                "Main",
                systemImage: "house",
                value: .home
            ) {
                NavigationStack(path: $router.path) {
                    Text("Main page")
                        .toolbar {
                            ToolbarItem(placement: .primaryAction) {
                                Button {
                                    router.push(MainFlow.friendRequests(user))
                                } label: {
                                    Image(systemName: "person.checkmark.and.xmark")
                                        .foregroundStyle(.blue)
                                        .badge(friendRequestBadges)
                                }
                                .buttonStyle(.glass)
                            }
                        }
                        .onAppear {
                            Task {
                                do {
                                    friendRequestBadges = try await UserClient.actualFriendRequests(for: user).count
                                } catch {
                                    print(error.localizedDescription)
                                    print(#file)
                                }
                            }
                        }
                        .navigationDestination(for: MainFlow.self) { $0.body }
                }
            }
            
            Tab(
                "",
                systemImage: "magnifyingglass",
                value: .search,
                role: .search
            ) {
                NavigationStack(path: $router.path) {
                    SearchMateView(user: user, mateClient: mateClient, displayedUsers: displayedMates)
                        .searchable(text: $mateRequest)
                }
            }
        }
        .onChange(of: mateRequest) { _, userPreffix in
            Task {
                displayedMates = await userService.searchViaPreffix(senderId: user.id, userPreffix)
            }
        }
    }
}

#Preview {
    ChatClient(router: Router())
}
