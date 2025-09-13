//
//  File.swift
//  ChatServer
//
//  Created by setuper on 13.09.2025.
//

import Vapor

enum ConnectionManagerError: Error {
    
    case socketDidNotConnected
}

protocol IConnectionManager {
    
    func newConnection(
        with id: UUID,
        _ ws: WebSocket
    ) -> Result<Void, ConnectionManagerError>
    
    func removeConnection(
        with id: UUID
    ) -> Result<WebSocket, ConnectionManagerError>
    
    func toAllConnections(_ completion: @escaping (UUID, WebSocket) -> Void)
    
    func totalConnectionCount() -> Int
}

final class ConnectionManager: IConnectionManager {
    
    private var activeConnections: [UUID: WebSocket] = [:]
    private let lock: NSLock = .init()
    
    func newConnection(
        with id: UUID,
        _ ws: WebSocket
    ) -> Result<Void, ConnectionManagerError> {
        lock.lock()
        defer { lock.unlock() }
        activeConnections[id] = ws
        return .success(())
    }
    
    func removeConnection(
        with id: UUID
    ) -> Result<WebSocket, ConnectionManagerError> {
        lock.lock()
        defer { lock.unlock() }
        guard let disconnectedWS = activeConnections[id] else {
            return .failure(.socketDidNotConnected)
        }
        activeConnections.removeValue(forKey: id)
        return .success(disconnectedWS)
    }
    
    func toAllConnections(_ completion: @escaping (UUID, WebSocket) -> Void) {
        lock.lock()
        defer { lock.unlock() }
        activeConnections.forEach { connectedId, connectedSocket in
            completion(connectedId, connectedSocket)
        }
    }
    
    func totalConnectionCount() -> Int {
        lock.lock()
        defer { lock.unlock() }
        return activeConnections.count
    }
}
