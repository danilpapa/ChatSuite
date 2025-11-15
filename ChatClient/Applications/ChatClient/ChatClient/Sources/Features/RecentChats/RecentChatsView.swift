//
//  RecentChatsView.swift
//  ChatClient
//
//  Created by setuper on 16.10.2025.
//

import SwiftUI

struct RecentChatsView: View {
    @EnvironmentObject var router: Router
    @State private var isFetchingRequest = false
    @State private var recentChats: [Chat] = []
    
    private var user: User
    private var chatService: IChatService
    
    init(
        user: User,
        chatService: IChatService
    ) {
        self.user = user
        self.chatService = chatService
    }
    
    var body: some View {
        Group {
            if recentChats.isEmpty {
                Button {
                    
                } label: {
                    Text("No recent chats, start chatting now")
                }
                .opacity(recentChats.isEmpty ? 1 : 0)
                .disabled(!recentChats.isEmpty)
            } else {
                List {
                    ForEach(recentChats) { chat in
                        Text(chat.mateEmail)
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                }
                .overlay {
                    ProgressView()
                        .opacity(isFetchingRequest ? 1 : 0)
                }
            }
        }
        .task {
            Task {
                recentChats = await chatService.loadRecentChats(for: user)
            }
        }
    }
}
