//
//  File.swift
//  ChatServer
//
//  Created by setuper on 19.12.2025.
//

import Vapor

actor NotificationManager {
    public var connections: [String: WebSocket] = [:]
    
    public init() { }
    
    func register(userId: String, webSocket: WebSocket) {
        connections[userId] = webSocket
        
        webSocket.onClose.whenComplete { _ in
            Task {
                await self.disconnect(userId: userId)
            }
        }
    }
    
    func disconnect(userId: String) {
        connections.removeValue(forKey: userId)
    }
    
    public func incomingNotification(to userId: String) async throws {
        guard let ws = connections[userId] else { return }
        let requestData = try JSONEncoder().encode(_IncomingChatRequest(peerId: userId))
        ws.send(requestData)
    }
}

struct NotificationController: RouteCollection {
    private let notificationManager: NotificationManager
    
    public init(notificationManager: NotificationManager) {
        self.notificationManager = notificationManager
    }
    
    func boot(routes: any RoutesBuilder) throws {
        routes.webSocket("connect") { req, ws in
            handleWebSocket(req: req, ws: ws)
        }
    }
    
    private func handleWebSocket(req: Request, ws: WebSocket) {
        ws.eventLoop.execute {
            Task {
                guard let userId = req.valueForHeader("user_id") else { return }
                await notificationManager.register(userId: userId, webSocket: ws)
            }
        }
    }
}

public struct _IncomingChatRequest: Content {
    
    let peerId: String
    
    enum CodingKeys: String, CodingKey {
        case peerId = "peer_id"
    }
}
