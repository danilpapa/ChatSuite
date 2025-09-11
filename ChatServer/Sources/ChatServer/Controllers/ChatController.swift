//
//  File.swift
//  ChatServer
//
//  Created by setuper on 06.09.2025.
//

import Vapor

struct ChatController: RouteCollection {
    nonisolated(unsafe) static var activeConnections: [WebSocket] = []
    
    func boot(routes: any Vapor.RoutesBuilder) throws {
        
        routes.webSocket("chat") { req, ws in
            handleWebSocket(req: req, ws: ws)
        }
    }
    
    private func handleWebSocket(req: Request, ws: WebSocket) {
        if !ChatController.activeConnections.contains(where: { connectedWs in
            connectedWs === ws
        }) {
            ChatController.activeConnections.append(ws)
        }
        
        broadcastConnectionCount(ChatController.activeConnections.count)
        
        ws.onText { ws, text in
            handleIncommingMessage(text)
        }
        
        ws.onClose.whenComplete { _ in
            ChatController.activeConnections.removeAll { connectedWs in
                connectedWs === ws
            }
            broadcastConnectionCount(ChatController.activeConnections.count)
        }
    }
    
    private func handleIncommingMessage(_ text: String) {
        if let data = text.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let type = json["type"] as? String
        {
            switch ServerResponceType(rawValue: type) {
            case .connectionQuantity:
                if let quantity = json["count"] as? Int {
                    broadcastConnectionCount(quantity)
                }
            default:
                break
            }
        } else {
            broadcastChatMessage(text)
        }
    }
    
    private func broadcastChatMessage(_ message: String) {
        ChatController.activeConnections.forEach { ws in
            ws.send(message)
        }
    }
    
    private func broadcastConnectionCount(_ quantity: Int) {
        let message = """
        {
            "type": "connection_count",
            "count": \(quantity)
        }
        """
        
        ChatController.activeConnections.forEach { ws in
            ws.send(message)
        }
    }
}

fileprivate enum ServerResponceType: String {

    case connectionQuantity = "connection_count"
}
