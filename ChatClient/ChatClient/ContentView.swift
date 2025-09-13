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

@Observable
final class WebSocketManager {
    
    var messages: [String] = []
    var connectedCount: Int = 0
    private var webSocketTask: URLSessionWebSocketTask?
    
    func connect() {
        webSocketTask = URLSession.shared.webSocketTask(with: EndPoints.socketBaseUrl)
        webSocketTask?.resume()
        
        Task {
            await receiveMessages()
        }
    }
    
    private func receiveMessages() async {
        while webSocketTask?.state == .running {
            do {
                let result = try await webSocketTask?.receive()
                switch result {
                case let .data(data):
                    let decoder = JSONDecoder()
                    do {
                        let messageType = try decoder.decode(ServerMessagesType.self, from: data)
                        switch MessageType(rawValue: messageType.type) {
                        case .chatMessage:
                            let chatMessage = try decoder.decode(ChatMessage.self, from: data)
                            self.messages.append(chatMessage.text)
                            break
                        case .connectedQuantity:
                            let quantity = try decoder.decode(ConnectionMessage.self, from: data)
                            self.connectedCount = quantity.count
                        case .clearChat:
                            self.messages.removeAll()
                        default:
                            break
                        }
                    } catch {
                        // handle
                    }
                case .string(_):
                    // Handle string
                    print()
                    break
                default:
                    break
                }
            } catch {
                print("Receive error: \(error)")
                break
            }
        }
    }
    
    func sendMessage(_ message: String) async throws {
        let message = """
        {
            "type": "text_message",
            "message": \(message)
        }
        """
        let taskMessage = URLSessionWebSocketTask.Message.string(message)
        try await webSocketTask?.send(taskMessage)
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: "Some reason".data(using: .utf8))
        DispatchQueue.main.async {
            self.messages.removeAll()
        }
    }
}

fileprivate enum EndPoints {
    
    static let socketBaseUrl: URL = .init(string: "ws://localhost:8080/chat")!
}

private enum MessageType: String {
    
    case connectedQuantity = "connection_message"
    case chatMessage = "chat_message"
    case clearChat = "clear_chat"
}

struct ConnectionMessage: Decodable {
    
    let count: Int
}

struct ChatMessage: Decodable {
    
    let text: String
}

struct ClearChat: Decodable { }

struct ServerMessagesType: Decodable {
    let type: String
}

public extension String {
    
    static let chatMessage: Self = "chat_message"
    static let connectedQuantity: Self = "connection_message"
    static let clearChat: Self = "clear_chat"
}
