//
//  RecentChatsView.swift
//  ChatClient
//
//  Created by setuper on 16.10.2025.
//

import SwiftUI

struct Chat: Identifiable {
    
    let peerDisplayedName: String
    
    var id: String {
        peerDisplayedName
    }
}

private typealias VM = RecentChatsViewModel

private final class RecentChatsViewModel: ObservableObject {
    private var user: User
    @Published var recentChats: [Chat] = [] // = ...load from back
    @Published var isFetchingRequest: Bool = false
    
    init(user: User) {
        self.user = user
    }
    
    func loadRecentChats() async throws {
        let recentChats = try await NetworkManager.shared.obtainRecentChats(for: user.id)
        self.recentChats = recentChats.map {
            let peer = user.email == $0.userHost1.email ? $0.userHost2 : $0.userHost1
            return Chat(peerDisplayedName: peer.email)
        }
    }
}

struct RecentChatsView: View {
    @StateObject private var vm: VM
    
    init(for user: User) {
        self._vm = StateObject(wrappedValue: RecentChatsViewModel(user: user))
    }
    
    var body: some View {
        List {
            ForEach(vm.recentChats) { chat in
                Text(chat.peerDisplayedName)
                    .font(.title)
                    .fontWeight(.semibold)
            }
        }
        .overlay {
            Color.white.opacity(vm.isFetchingRequest ? 0.85 : 0)
            ProgressView()
                .opacity(vm.isFetchingRequest ? 1 : 0)
        }
        .task {
            do {
                try await vm.loadRecentChats()
            } catch {
                print("Erorr fetching recent chats: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    RecentChatsView(for: .anonymous())
}
