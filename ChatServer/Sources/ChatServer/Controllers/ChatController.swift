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
            handleWebSocket(req: req, ws: ws)
        }
        
        cryptoKeyRequest.post { req -> HTTPStatus in
            do {
                let keyRequest = try handleCryptoKey(req: req)
                let data = try idAndKeyFromModel(keyRequest)
                do {
                    let receiverWS = try connectionManager.receiverSocket(from: data.id)
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
    
    private func idAndKeyFromModel(_ model: PublicKeyRequest) throws -> (id: UUID, key:  CryptoPublic) {
        do {
            guard
                let id = UUID(uuidString: model.user_id),
                let publicKeyData = Data(base64Encoded: model.public_key)
            else {
                throw Abort(.badRequest)
            }
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
    
    private func handleWebSocket(req: Request, ws: WebSocket) {
        let id: UUID = .init()
        broadcastUserId(with: id, for: ws)
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
    
    private func broadcastUserId(with id: UUID, for ws: WebSocket) {
        let message = ConnectionId(id: id)
        sendMessage(message, to: ws)
    }
    
    private func handleIncommingMessage(_ text: String, from connectionID: UUID) {
        let chatMessage = ChatMessage(
            text: text,
            sender: connectionID.uuidString,
            sentAt: .now
        )
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
