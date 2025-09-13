//
//  WebSocketManager.swift
//  ChatClient
//
//  Created by setuper on 13.09.2025.
//

import Foundation

@Observable
final class WebSocketManager: NSObject {
    
    var messages: [String] = []
    var connectedCount: Int = 0
    private var webSocketTask: URLSessionWebSocketTask?
    
    func connect() {
        let session = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: .main
        )
        webSocketTask = session.webSocketTask(with: EndPoints.socketBaseUrl)
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

extension WebSocketManager: URLSessionDelegate {
    
    /// Only in DEBUG!
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}
