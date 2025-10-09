//
//  ContentView.swift
//  ChatClient
//
//  Created by setuper on 06.09.2025.
//

import SwiftUI

struct ChatView: View {
    @State private var socketManager: WebSocketManager
    @State private var text: String = ""
    
    init(socketManager: WebSocketManager) {
        self.socketManager = socketManager
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(socketManager.messages) { message in
                    HStack {
                        if message.isYour { Spacer() }
                        VStack(alignment: .leading) {
                            Text(message.text)
                            Text(message.sentAt)
                                .font(.callout)
                        }
                        if !message.isYour { Spacer() }
                    }
                }
            }
            TextField("Enter message", text: $text)
                .disabled(socketManager.connectedUsers != 2)
                .onSubmit {
                    Task {
                        await socketManager.sendMessage(text)
                        text = ""
                    }
                }
        }
        .task {
            socketManager.connect()
            print("Connected")
        }
        .onDisappear {
            socketManager.disconnect()
        }
        .navigationTitle(socketManager.connectedUsers.description)
    }
}

public extension String {
    
    static let chatMessage: Self = "chat_message"
    static let connectedQuantity: Self = "connection_message"
    static let clearChat: Self = "clear_chat"
}
