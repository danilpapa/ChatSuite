//
//  File.swift
//  ChatServer
//
//  Created by setuper on 06.09.2025.
//

import Vapor

struct ChatController: RouteCollection, Sendable {
    private nonisolated(unsafe) let connectionManager: any IConnectionManager
    
    public init(connectionManager: any IConnectionManager) {
        self.connectionManager = connectionManager
    }
    
    func boot(routes: any Vapor.RoutesBuilder) throws {
        
        routes.webSocket("chat") { req, ws in
            handleWebSocket(req: req, ws: ws)
        }
    }
    
    private func handleWebSocket(req: Request, ws: WebSocket) {
        
        let id: UUID = .init()
        switch connectionManager.newConnection(with: id, ws) {
        case .success(_):
            broadcastConnectionCount()
        case let .failure(error):
            // handle error
            print(error)
        }
        
        ws.onText { ws, text in
            handleIncommingMessage(text, from: id)
        }
        
        ws.onClose.whenComplete { _ in
            switch connectionManager.removeConnection(with: id) {
            case .success(_):
                clearChat()
                broadcastConnectionCount()
            case let .failure(error):
                // handle error
                print(error)
            }
        }
    }
    
    private func handleIncommingMessage(_ text: String, from connectionID: UUID) {
        let chatMessage = ChatMessage(text: text, timeStamp: .now, sender: "\(connectionID)")
        sendToAllConnections(message: chatMessage)
    }
    
    private func broadcastConnectionCount() {
        let message = ConnectionMessage(count: connectionManager.totalConnectionCount())
        sendToAllConnections(message: message)
    }
    
    private func clearChat() {
        sendToAllConnections(message: ClearChat())
    }
    
    private func sendToAllConnections<T: Encodable>(message: T) {
        connectionManager.toAllConnections { _, ws in
            sendMessage(message, to: ws)
        }
    }
    
    private func sendMessage<T: Encodable>(_ message: T, to ws: WebSocket) {
        do {
            let data = try JSONEncoder().encode(message)
            ws.send(data)
        } catch {
            // handle
        }
    }
}
