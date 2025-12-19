//
//  ContentView.swift
//  ChatClient
//
//  Created by setuper on 06.09.2025.
//

import SwiftUI
import API
import Services
import DesignKit

struct ChatView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var appState: AppState
    @State private var socketManager: WebSocketManager
    @State private var text: String = ""
    @FocusState private var isFocused: Bool
    @State private var mateName: String = "Connecting..."
    @State private var mateMessageColor: Color = .accentColor
    
    init(socketManager: WebSocketManager) {
        self.socketManager = socketManager
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { proxy in
                    LazyVStack(spacing: 8) {
                        ForEach(socketManager.messages) { message in
                            HStack {
                                if message.isYour { Spacer() }
                                
                                HStack(
                                    alignment: .bottom,
                                    spacing: 4
                                ) {
                                    Text(message.text)
                                        .foregroundStyle(.white)
                                    Text(message.sentAt)
                                        .font(.caption2)
                                        .foregroundStyle(.white.opacity(0.8))
                                        .offset(y: 4)
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 5)
                                .glassEffect(.clear.tint(messageColor(for: message)))
                                
                                if !message.isYour { Spacer() }
                            }
                            .id(message.id)
                            .padding(.horizontal, 16)
                        }
                        Color.clear
                            .frame(height: 75)
                            .id("bottomAnchor")
                    }
                    .onChange(of: socketManager.messages.count) { _, _ in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            proxy.scrollTo("bottomAnchor", anchor: .bottom)
                        }
                    }
                }
            }
            .toolbar {
                Image(systemName: socketManager.connectedUsers == 1
                      ? "person.crop.circle.badge.clock.fill"
                      : "person.crop.circle.fill.badge.checkmark"
                )
                .foregroundStyle(socketManager.connectedUsers == 1 ? .red : .green)
            }
        }
        .animation(.smooth, value: socketManager.connectedUsers)
        .tabbarHidder()
        .overlay(alignment: .bottom) {
            InputView
        }
        .task {
            do {
                mateName = try await UserClient.shared.userName(
                    for: socketManager.peerUserId
                )
            } catch {
                print("error: \(error.localizedDescription)")
            }
            do {
                mateMessageColor = try await MateClient.shared.getMessageColor(
                    to: socketManager.peerUserId
                )
            } catch {
                print("error: \(error.localizedDescription)")
            }
            socketManager.onCloseConnection = {
                DispatchQueue.main.async {
                    router.pop()
                }
            }
            socketManager.connect()
        }
        .onAppear {
            appState.mateToChat = nil
        }
        .onDisappear {
            socketManager.disconnect()
        }
        .navigationTitle(mateName)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func messageColor(for message: Message) -> Color {
        message.isYour ? .green : mateMessageColor
    }
    
    @ViewBuilder
    private var InputView: some View {
        HStack {
            TextField("Enter message", text: $text)
                .lineLimit(1...6)
                .padding(18)
                .glassEffect(.regular)
                .padding()
                .onSubmit {
                    sendMessage()
                }
                .focused($isFocused)
            
            if isFocused {
                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(.white)
                        .padding()
                }
                .glassEffect(.regular.tint(text.isEmpty ? .blue : .green))
                .padding(.trailing)
                .transition(.move(edge: .trailing))
            }
        }
        .animation(.smooth, value: text)
        .animation(.default, value: isFocused)
        .offset(y: socketManager.connectedUsers != 2 ? 200 : 0)
        .animation(.spring, value: socketManager.connectedUsers)
    }
    
    private func sendMessage() {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        Task {
            await socketManager.sendMessage(trimmed)
            text = ""
            isFocused = false
        }
    }
}

public extension String {
    
    static let chatMessage: Self = "chat_message"
    static let connectedQuantity: Self = "connection_message"
    static let clearChat: Self = "clear_chat"
}

#if DEBUG
#Preview {
    NavigationStack {
        ChatView(
            socketManager: WebSocketManager(
                cryptoKeysManager: CryptoManager(),
                userId: User.danilMaybach().id,
                peerId: User.maybachDanil().id
            )
        )
        .environmentObject(AppState(user: .danilMaybach()))
    }
}
#endif
