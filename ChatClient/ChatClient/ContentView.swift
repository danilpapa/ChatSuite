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
                case let .string(string):
                    print(string)
                    if let data = string.data(using: .utf8),
                       let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    {
                        if let message = json["text_message"] as? String {
                            await MainActor.run {
                                messages.append(message)
                            }
                        } else if let connectedCount = json["count"] as? Int {
                            await MainActor.run {
                                self.connectedCount = connectedCount
                            }
                        }
                    }
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
        await MainActor.run {
            messages.append("Client: \(message)")
        }
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: "Some reason".data(using: .utf8))
    }
}

fileprivate enum EndPoints {
    
    static let socketBaseUrl: URL = .init(string: "ws://localhost:8080/chat")!
}
