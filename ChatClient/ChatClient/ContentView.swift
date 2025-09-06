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
        VStack {
            List(socketManager.messages, id: \.self) { message in
                Text(message)
            }
            TextField("Enter message", text: $text)
                .onSubmit {
                    Task {
                        try? await socketManager.sendMessage(text)
                        text = ""
                    }
                }
        }
        .padding()
        .task {
            socketManager.connect()
        }
    }
}

@Observable
final class WebSocketManager {
    
    var messages: [String] = []
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
                    await MainActor.run {
                        messages.append("Server: \(string)")
                    }
                case let .data(data):
                    await MainActor.run {
                        messages.append("Data: \(data)")
                    }
                case .none:
                    break
                @unknown default:
                    break
                }
            } catch {
                print("Receive error: \(error)")
                break
            }
        }
    }
    
    func sendMessage(_ message: String) async throws {
        let message = URLSessionWebSocketTask.Message.string(message)
        try await webSocketTask?.send(message)
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
