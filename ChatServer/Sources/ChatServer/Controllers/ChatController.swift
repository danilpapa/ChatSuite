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

        ws.onText { ws, text in
            if !ChatController.activeConnections.contains(where: { connectedSocket in
                connectedSocket === ws
            }) {
                ChatController.activeConnections.append(ws)
            }
            
            ChatController.activeConnections.forEach { connectedWs in
                if connectedWs !== ws {
                    connectedWs.send(text)
                }
            }
        }
        
        ws.onClose.whenComplete { _ in 
            ChatController.activeConnections.removeAll { connectedWs in
                connectedWs === ws
            }
        }
    }
}
