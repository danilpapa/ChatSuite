//
//  MainVie4w.swift
//  ChatClient
//
//  Created by setuper on 20.09.2025.
//

import SwiftUI

enum TabIdentifier: Hashable {
    case search,
         home
}

struct MainView: View {
    @EnvironmentObject var router: Router
    @State private var selected: TabIdentifier = .home
    @State private var mateRequest: String = ""
    @State private var displayedMates: [User] = []
    
    var user: User
    var userService: IUserService
    
    var body: some View {
        TabView(selection: $selected) {
            Tab(
                "Main",
                systemImage: "house",
                value: .home
            ) {
                NavigationStack(path: $router.path) {
                    Text("Main page")
                        .navigationDestination(for: AppRoute.self) { route in
                            switch route {
                            case .main(let mainFlow):
                                switch mainFlow {
                                case let .friendRequests(user):
                                    Text("Add")
                                default: fatalError()
                                }
                            default: fatalError()
                            }
                        }
                        .toolbar {
                            ToolbarItem(placement: .primaryAction) {
                                Button {
                                    router.push(.main(.friendRequests(user)))
                                } label: {
                                    Image(systemName: "person.checkmark.and.xmark")
                                        .foregroundStyle(.background)
                                }
                                .buttonStyle(.glassProminent)
                            }
                        }
                }
            }
            
            Tab(
                "",
                systemImage: "magnifyingglass",
                value: .search,
                role: .search
            ) {
                NavigationStack(path: $router.path) {
                    SearchMateView(displayedUsers: displayedMates)
                        .searchable(text: $mateRequest)
                        .navigationDestination(for: MainFlow.self) { route in
                            switch route {
                            case let .mateStatusPage(mate):
                                MateStatusPageView(mate: mate, mateStatusService: MateStatusService())
                            default: fatalError()
                            }
                        }
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
    MainView(user: .danilMaybach(), userService: UserService())
        .environmentObject(Router())
        .environmentObject(LoginState())
}
