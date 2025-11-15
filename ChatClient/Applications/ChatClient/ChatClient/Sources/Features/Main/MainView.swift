//
//  MainVie4w.swift
//  ChatClient
//
//  Created by setuper on 20.09.2025.
//

import SwiftUI

enum TabIdentifier: Hashable {
    case search
}

struct MainView: View {
    @State private var selected: TabIdentifier = .search
    @State private var mateRequest: String = ""
    @State private var displayedMates: [User] = []
    
    var userService: IUserService
    
    var body: some View {
        TabView(selection: $selected) {
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
                displayedMates = await userService.searchViaPreffix(userPreffix)
            }
        }
    }
}
