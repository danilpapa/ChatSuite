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
                NavigationStack {
                    Text("Main page")
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
                NavigationStack {
                    SearchMateView(displayedUsers: displayedMates)
                        .searchable(text: $mateRequest)
                }
            }
        }
        .onChange(of: mateRequest) { _, userPreffix in
            Task {
                displayedMates = await userService.searchViaPreffix(senderId: user.id, userPreffix)
            }
        }
        .navigationDestination(for: AppRoute.self) { route in
            switch route {
            case .auth(let authenticationFlow):
                switch authenticationFlow {
                case .login:
                    LoginView(googleSignInService: GoogleSignInService())
                }
            case .main(let mainFlow):
                switch mainFlow {
                case let .mateStatusPage(mate):
                    MateStatusPageView(
                        mate: mate,
                        mateStatusService: MateStatusService()
                    )
                case let .friendRequests(user):
                    Color.red
                }
            }
        }
    }
}

#Preview {
    MainView(user: .danilMaybach(), userService: UserService())
        .environmentObject(Router())
        .environmentObject(LoginState())
}
