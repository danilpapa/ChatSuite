//
//  ContentView.swift
//  ChatClient
//
//  Created by setuper on 06.09.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var socketManager = WebSocketManager()
    @State private var text: String = ""
    
    var body: some View {
        NavigationStack {
            NavigationLink("Chat") {
                VStack {
                    List(socketManager.messages, id: \.self) { message in
                        Text(message)
                    }
                    TextField("Enter message", text: $text)
                        .disabled(socketManager.connectedCount != 2)
                        .onSubmit {
                            Task {
                                try? await socketManager.sendMessage(text)
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
                .navigationTitle(socketManager.connectedCount.description)
            }
        }
    }
}

public extension String {
    
    static let chatMessage: Self = "chat_message"
    static let connectedQuantity: Self = "connection_message"
    static let clearChat: Self = "clear_chat"
}
