//
//  File.swift
//  ChatServer
//
//  Created by setuper on 06.09.2025.
//

import Vapor

private typealias CryptoPublic = Curve25519.KeyAgreement.PrivateKey.PublicKey

struct ChatController: RouteCollection, Sendable {
    private nonisolated(unsafe) let connectionManager: any IConnectionManager
    
    private let dateEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    
    public init(connectionManager: any IConnectionManager) {
        self.connectionManager = connectionManager
    }
    
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let cryptoKeyRequest = routes.grouped("publicKey")
        
        routes.webSocket("chat") { req, ws in
            Task {
                await handleWebSocket(req: req, ws: ws)
            }
        }
        
        cryptoKeyRequest.post { req -> HTTPStatus in
            do {
                let keyRequest = try handleCryptoKey(req: req)
                let data = try idAndKeyFromModel(keyRequest)
                do {
                    let receiverWS = try connectionManager.user(id: data.peerId)
                    let publicKeyMessage = PublicKeyMesage(key: data.key.rawRepresentation)
                    sendMessage(
                        publicKeyMessage,
                        to: receiverWS
                    )
                }
                return .ok
            } catch {
                throw Abort(.badRequest)
            }
        }
    }
    
    private func idAndKeyFromModel(_ model: PublicKeyRequest) throws -> (peerId: String, key:  CryptoPublic) {
        do {
            guard
                let publicKeyData = Data(base64Encoded: model.public_key)
            else {
                throw Abort(.badRequest)
            }
            let id = model.peer_id
            let publicKey = try CryptoPublic(rawRepresentation: publicKeyData)
            return (id, publicKey)
        } catch {
            // handle
            throw Abort(.badRequest)
        }
    }
    
    private func handleCryptoKey(req: Request) throws -> PublicKeyRequest {
        return try req.content.decode(PublicKeyRequest.self)
    }
    
    private func handleWebSocket(req: Request, ws: WebSocket) async {
        guard let hostId = req.valueForHeader("host-id"),
              let peerId = req.valueForHeader("peer-id")
        else { return }
          
        do {
            try await connectionManager.newConnection(
                db: req.db,
                host: hostId,
                peer: peerId, ws
            )
        } catch {
            fatalError(error.localizedDescription)
        }
        
        broadcastConnectionCount(with: hostId)
        
        ws.onText { ws, text in
            handleIncommingMessage(text, from: hostId)
        }
        
        ws.onClose.whenComplete { _ in
            connectionManager.removeConnection(from: hostId)
        }
    }
    
    private func handleIncommingMessage(_ text: String, from connectionID: String) {
        let chatMessage = ChatMessage(
            text: text,
            sender: connectionID,
            sentAt: .now
        )
        sendToAllConnections(message: chatMessage, with: connectionID)
    }
    
    private func broadcastConnectionCount(with memberId: String) {
        let message = ConnectionMessage(count: connectionManager.totalConnectionCount(memberId: memberId))
        sendToAllConnections(message: message, with: memberId)
    }
    
    private func clearChat(with memberId: String) {
        sendToAllConnections(message: ClearChat(), with: memberId)
    }
    
    private func sendToAllConnections<T: Encodable>(message: T, with memberId: String) {
        connectionManager.toAllConnections(memberId: memberId) { ws in
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
