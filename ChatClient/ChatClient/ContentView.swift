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
                if message.hasPrefix("Client") {
                    Spacer()
                }
                Text(message)
                if message.hasPrefix("Server") {
                    Spacer()
                }
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
            do {
                try await socketManager.connect()
            } catch {
                print("Some connecting error: \(error)")
            }
        }
    }
}

@Observable
final class WebSocketManager {
    
    var messages: [String] = []
    private var webSocketTask: URLSessionWebSocketTask?
    
    func connect() async throws {
        webSocketTask = URLSession.shared.webSocketTask(with: EndPoints.socketBaseUrl)
        webSocketTask?.resume()
        
        try await receiveMessage()
    }
    
    func receiveMessage() async throws {
        let result = try await webSocketTask?.receive()
        switch result {
        case let .string(string):
            messages.append("Сервер \(string)")
        case let .some(.data(data)):
            messages.append("\(data)")
        case .none:
            break
        @unknown default:
            break
        }
        try await self.receiveMessage()
    }
    
    func sendMessage(_ message: String) async throws {
        let message = URLSessionWebSocketTask.Message.string(message)
        try await webSocketTask?.send(message)
        messages.append("Client: \(message)")
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: "Some reason".data(using: .utf8))
    }
}

fileprivate enum EndPoints {
    
    static let socketBaseUrl: URL = .init(string: "ws://localhost:8080/chat")!
}
