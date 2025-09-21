//
//  WebSocketManager.swift
//  ChatClient
//
//  Created by setuper on 13.09.2025.
//

import Foundation
import SwiftUI

struct MessageModel: Hashable, Identifiable {
    let id: UUID = .init()
    
    let text: String
    let isYour: Bool
    let sentAt: String
}

@Observable
final class WebSocketManager: NSObject {
    
    var userId: UUID
    var peerUserId: UUID
    
    var connectedUsers: Int = 0
    var messages: [MessageModel] = []

    private var webSocketTask: URLSessionWebSocketTask?
    private var cryptoKeysManager: ICryptoManager
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    init(cryptoKeysManager: ICryptoManager, userId: UUID, peerId: UUID) {
        self.cryptoKeysManager = cryptoKeysManager
        self.userId = userId
        self.peerUserId = peerId
        super.init()
    }
    
    func connect() {
        let session = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: .main
        )
        let url = EndPoints.chatUrl.url
        var request = URLRequest(url: url)
        
        request.setValue(userId.uuidString, forHTTPHeaderField: "host-id")
        request.setValue(peerUserId.uuidString, forHTTPHeaderField: "peer-id")
        
        webSocketTask = session.webSocketTask(with: request)
        webSocketTask?.resume()
        
        Task {
            await receiveMessages()
        }
    }
    
    private func receiveMessages() async {
        while webSocketTask?.state == .running {
            do {
                let result = try await webSocketTask?.receive()
                handleWebSocketResult(result)
            } catch {
                print("Receive error: \(error)")
                break
            }
        }
    }
    
    private func handleWebSocketResult(_ result: URLSessionWebSocketTask.Message?) {
        switch result {
        case let .data(data):
            let decoder = JSONDecoder()
            do {
                let messageType = try decoder.decode(ServerMessagesType.self, from: data)
                switch MessageType(rawValue: messageType.type) {
                case .chatMessage:
                    let chatMessage = try decoder.decode(ChatMessage.self, from: data)
                    guard
                        let encryptedData = Data(base64Encoded: chatMessage.text),
                        let id = UUID(uuidString: chatMessage.senderId)
                    else {
                        print("Error via decondig base64")
                        return
                    }
                    messages.append(
                        MessageModel(
                            text: cryptoKeysManager.decryptMessage(encryptedData),
                            isYour: id == userId,
                            sentAt: dateFormatter.string(from: chatMessage.sentAt)
                        )
                    )
                case .connectedQuantity:
                    let quantity = try decoder.decode(ConnectionMessage.self, from: data)
                    connectedUsers = quantity.count
                    if connectedUsers == 2 {
                        generateCryptoKeys()
                    }
                case .connectionId:
                    let id = try decoder.decode(ConnectionId.self, from: data).id
                    userId = id
                case .publicKeyMessage:
                    let publicKey = try decoder.decode(PublicKeyMesage.self, from: data)
                    let sharedPublicKey = try PublicKey(rawRepresentation: publicKey.key)
                    do {
                        try cryptoKeysManager.updateOtherClientKey(sharedPublicKey)
                    } catch {
                        print(error)
                    }
                case .clearChat:
                    messages.removeAll()
                case .none:
                    break
                }
            } catch {
                print(error)
            }
        case .none, .some(_):
            break
        }
    }
    
    func sendMessage(_ message: String) async throws {
        guard let messageData = message.data(using: .utf8) else {
            return
        }
        do {
            let encryptedMessageResult = cryptoKeysManager.encryptMessage(messageData)
            switch encryptedMessageResult {
            case let .success(encryptedMessage):
                let taskMessage = URLSessionWebSocketTask.Message.string(encryptedMessage.base64EncodedString())
                try await webSocketTask?.send(taskMessage)
            case .failure(_):
                throw CryptoKeyManagerError.encryptedMessage
            }
        } catch {
            print(error)
        }
    }
    
    func disconnect() {
        webSocketTask?.cancel(
            with: .goingAway,
            reason: "Some reason".data(using: .utf8)
        )
        DispatchQueue.main.async {
            self.messages.removeAll()
            self.connectedUsers -= 1
        }
    }
    
    @discardableResult
    private func generateCryptoKeys() -> Result<Void, ServerEndpointsError> {
        guard let publicData = Data(base64Encoded: cryptoKeysManager.publicKey.rawRepresentation.base64EncodedString()) else {
            return .failure(.encodePublicKey)
        }
        Task {
            await NetworkManager.shared.sendPublicKey(
                key: publicData,
                from: userId,
                to: peerUserId
            )
        }
        return .success(()) /// Additional handling here
    }
}

extension WebSocketManager: URLSessionDelegate {
    
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}
