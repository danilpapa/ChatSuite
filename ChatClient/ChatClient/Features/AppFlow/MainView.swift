//
//  MainVie4w.swift
//  ChatClient
//
//  Created by setuper on 20.09.2025.
//

import SwiftUI

enum TabIdentifier: Hashable {
    case settings,
         search,
         recents
}

struct MainView: View {
    @State private var selected: TabIdentifier = .recents
    
    var user: User
    
    let userId: String = "0TTAKXoKRLdlDMUdgxMQsE0sp462"
    let peerId: String = "YSXfM6v2OpRacZLjCD7g64BhUvT2"
    
    var body: some View {
        TabView(selection: $selected) {
            Tab(
                "",
                systemImage: "person.fill.badge.plus",
                value: .search,
                role: .search
            ) {
                NavigationStack {
                    SearchMateView()
                }
            }
            
            Tab("", systemImage: "message.badge", value: .recents) {
//                RecentChatsView(for: )
            }
            
//            Tab("", systemImage: "house.fill", value: .home) {
//                NavigationLink {
//                    ChatView(socketManager: WebSocketManager(cryptoKeysManager: CryptoManager(), userId: userId, peerId: peerId))
//                } label: {
//                    Text("Chat \(userId)")
//                }
//            }
        }
    }
}
