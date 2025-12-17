//
//  File.swift
//  ChatServer
//
//  Created by setuper on 13.09.2025.
//

import Foundation
import Vapor
import Fluent

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
    
    func newConnection (
        db: any Database,
        host hostId: String,
        peer peerId: String,
        _ ws: WebSocket
    ) async throws
    
    func removeConnection(from hostId: String)
    func toAllConnections(memberId: String, _ completion: @escaping (WebSocket) -> Void)
    func totalConnectionCount(memberId: String) -> Int
    func user(id: String) throws -> WebSocket
}

final class ConnectionManager: IConnectionManager {
    
    private var activeLobbies: [FireLobby] = []
    private let lock: NSLock = .init()
    
    func newConnection(
        db: any Database,
        host hostId: String,
        peer peerId: String,
        _ ws: WebSocket
    ) async throws {
        if let peerLobbyIndex = self.activeLobbies.firstIndex(where: { lobby in
            lobby.hostId == hostId || lobby.hostId == peerId
        }) {
            self.activeLobbies[peerLobbyIndex].peerConnected(ws)
            let hostId = UUID(uuidString: hostId)!,
                peerId = UUID(uuidString: peerId)!
//            do {
//                if let existingChat = try await RecentChats
//                    .query(on: db)
//                    .group(.or, { group in
//                        group.filter(\.$userHost1.$id == hostId)
//                        group.filter(\.$userHost2.$id == peerId)
//                    })
//                    .first()
//                {
//                    existingChat.updatedAt = .now
//                    try await existingChat.save(on: db)
//                } else {
//                    let newRecentChat = RecentChats(userHost1ID: hostId, userHost2ID: peerId, updatedAt: .now)
//                    try await newRecentChat.save(on: db)
//                }
//            } catch {
//                throw Abort(.badGateway, reason: "Error during finding recent chat with host: \(hostId), and peer: \(peerId)")
//            }
        } else {
            let fireLobby = FireLobby(hostId: hostId, hostWebSocket: ws, peerData: (peerId, nil))
            activeLobbies.append(fireLobby)
        }
    }
    
    func removeConnection(
        from hostId: String
    ) {
        lock.lock()
        defer { lock.unlock() }
        self.activeLobbies.removeAll { lobby in
            lobby.hostId == hostId || lobby.peerData.0 == hostId
        }
    }
    
    func toAllConnections(memberId: String, _ completion: @escaping (WebSocket) -> Void) {
        lock.lock()
        defer { lock.unlock() }
        guard let activeLobby = self.activeLobbies.first (where: { lobby in
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
        guard let activeLobby = self.activeLobbies.first (where: { lobby in
            lobby.hostId == memberId || lobby.peerData.0 == memberId
        }) else {
            return -1
        }
        return activeLobby.isActive ? 2 : 1
    }
    
    func user(id: String) throws -> WebSocket {
        guard let activeLobby = self.activeLobbies.first (where: { lobby in
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
