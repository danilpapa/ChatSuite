//
//  File.swift
//  ChatServer
//
//  Created by setuper on 06.09.2025.
//

import Vapor

struct ChatController: RouteCollection {
    // TODO: Connection manager with lock
    nonisolated(unsafe) static var activeConnections: [UUID: WebSocket] = [:]
    
    func boot(routes: any Vapor.RoutesBuilder) throws {
        
        routes.webSocket("chat") { req, ws in
            handleWebSocket(req: req, ws: ws)
        }
    }
    
    private func handleWebSocket(req: Request, ws: WebSocket) {
        
        let id: UUID = .init()
        ChatController.activeConnections[id] = ws
        
        broadcastConnectionCount()
        
        ws.onText { ws, text in
            handleIncommingMessage(text, from: id)
        }
        
        ws.onClose.whenComplete { _ in
            ChatController.activeConnections.removeValue(forKey: id)
            clearChat()
            broadcastConnectionCount()
        }
    }
    
    private func handleIncommingMessage(_ text: String, from connectionID: UUID) {
        let chatMessage = ChatMessage(text: text, timeStamp: .now, sender: "\(connectionID)")
        sendToAllConnections(message: chatMessage)
    }
    
    private func broadcastConnectionCount() {
        let message = ConnectionMessage(count: ChatController.activeConnections.count)
        sendToAllConnections(message: message)
    }
    
    private func sendToAllConnections<T: Encodable>(message: T) {
        ChatController.activeConnections.values.forEach { ws in
            sendMessage(message, to: ws)
        }
    }
    
    private func clearChat() {
        sendToAllConnections(message: ClearChat())
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
