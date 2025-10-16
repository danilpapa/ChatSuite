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
        
        loadRecentChats()
    }
    
    private func loadRecentChats() {
        isFetchingRequest = true
        Main(delay: 2) {
            let mockData: [Chat] = [
                .init(peerDisplayedName: "t.fairushin@ya.ru"),
                .init(peerDisplayedName: "itpavel@t-bank.ru"),
                .init(peerDisplayedName: "maybach_danil")
            ]
            self.recentChats = mockData
            self.isFetchingRequest = false
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
    }
}

#Preview {
    RecentChatsView(for: .anonymous())
}
