//
//  File.swift
//  ChatServer
//
//  Created by setuper on 13.09.2025.
//

import Foundation
import Vapor

struct FireLobby: Equatable {
    
    static func ==(lhs: FireLobby, rhs: FireLobby) -> Bool {
        lhs.hostId == rhs.hostId
    }
    
    let hostId: String
    let hostWebSocket: WebSocket
    var peerData: (String, WebSocket?)
    var isActive: Bool = false
    
    mutating func peerConnected(_ peerWs: WebSocket) {
        self.peerData.1 = peerWs
        self.isActive = true
    }
    
    func activeConnections() -> [WebSocket] {
        guard let peerSocket = peerData.1 else {
            return [hostWebSocket]
        }
        return [hostWebSocket, peerSocket]
    }
}

protocol IConnectionManager {
    
    func newConnection(
        host hostId: String,
        peer peerId: String,
        _ ws: WebSocket
    )
    
    func removeConnection(from hostId: String)
    func toAllConnections(memberId: String, _ completion: @escaping (WebSocket) -> Void)
    func totalConnectionCount(memberId: String) -> Int
    func user(id: String) throws -> WebSocket
}

final class ConnectionManager: IConnectionManager {
    
    private var acriveLobbies: [FireLobby] = []
    private let lock: NSLock = .init()
    
    func newConnection(
        host hostId: String,
        peer peerId: String,
        _ ws: WebSocket
    ) {
        lock.lock()
        defer { lock.unlock() }
        if let peerLobbyIndex = self.acriveLobbies.firstIndex(where: { lobby in
            lobby.hostId == hostId || lobby.hostId == peerId
        }) {
            self.acriveLobbies[peerLobbyIndex].peerConnected(ws)
        } else {
            let fireLobby = FireLobby(hostId: hostId, hostWebSocket: ws, peerData: (peerId, nil))
            acriveLobbies.append(fireLobby)
        }
    }
    
    func removeConnection(
        from hostId: String
    ) {
        lock.lock()
        defer { lock.unlock() }
        self.acriveLobbies.removeAll { lobby in
            lobby.hostId == hostId || lobby.peerData.0 == hostId
        }
    }
    
    func toAllConnections(memberId: String, _ completion: @escaping (WebSocket) -> Void) {
        lock.lock()
        defer { lock.unlock() }
        guard let activeLobby = self.acriveLobbies.first (where: { lobby in
            lobby.hostId == memberId || lobby.peerData.0 == memberId
        }) else {
            return
        }
        activeLobby.activeConnections().forEach { socket in
            completion(socket)
        }
    }
    
    func totalConnectionCount(memberId: String) -> Int {
        lock.lock()
        defer { lock.unlock() }
        guard let activeLobby = self.acriveLobbies.first (where: { lobby in
            lobby.hostId == memberId || lobby.peerData.0 == memberId
        }) else {
            return -1
        }
        return activeLobby.isActive ? 2 : 1
    }
    
    func user(id: String) throws -> WebSocket {
        guard let activeLobby = self.acriveLobbies.first (where: { lobby in
            lobby.hostId == id || lobby.peerData.0 == id
        }) else {
            throw ConnectionManagerError.noSuchLobby
        }
        if activeLobby.isActive {
            return activeLobby.hostId == id ? activeLobby.hostWebSocket : activeLobby.peerData.1!
        }
        throw ConnectionManagerError.lobbyIsNotActive
    }
}

enum ConnectionManagerError: Error {
    
    case socketDidNotConnected
    case noSuchLobby
    case lobbyIsNotActive
}
