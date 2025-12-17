//
//  WebSocketManager.swift
//  Services
//
//  Created by setuper on 16.12.2025.
//

import Foundation
import SwiftUI
import API

@Observable
public final class WebSocketManager: NSObject {
    
    private var userId: String
    private var peerUserId: String
    
    public var connectedUsers: Int = 0
    public var messages: [Message] = []

    private var webSocketTask: URLSessionWebSocketTask?
    private var cryptoKeysManager: ICryptoManager
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    public init(
        cryptoKeysManager: ICryptoManager,
        userId: UUID,
        peerId: UUID
    ) {
        self.cryptoKeysManager = cryptoKeysManager
        self.userId = userId.uuidString
        self.peerUserId = peerId.uuidString
        super.init()
    }
    
    public func connect() {
        let session = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: .main
        )
        let url = WebSocketURLBuilder.makeURL(for: "chat")
        var request = URLRequest(url: url)
        
        request.setValue(userId, forHTTPHeaderField: "host-id")
        request.setValue(peerUserId, forHTTPHeaderField: "peer-id")
        
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
                //Crashlytics.crashlytics().log("WebSocket receive failed")
                //Crashlytics.crashlytics().record(error: error)
                break
            }
        }
    }
    
    private func handleWebSocketResult(_ result: URLSessionWebSocketTask.Message?) {
        switch result {
        case let .data(data):
            let decoder = JSONDecoder()
            do {
                let messageType = try decoder.decode(MessageType_.self, from: data)
                switch MessageType(rawValue: messageType.type) {
                case .chatMessage:
                    let chatMessage = try decoder.decode(Message_.self, from: data)
                    guard let encryptedData = Data(base64Encoded: chatMessage.text)
                    else {
                        //Crashlytics.crashlytics().log("Error decoding base64 from chatMessage.text")
                        //Crashlytics.crashlytics().record(error: CryptoKeyManagerError.invalidDecryptedData)
                        return
                    }
                    let id = chatMessage.senderId
                    let decryptedMessage: String
                    do {
                        decryptedMessage = try cryptoKeysManager.decryptMessage(encryptedData)
                        messages.append(
                            Message(
                                text: decryptedMessage,
                                isYour: id == userId,
                                sentAt: dateFormatter.string(from: chatMessage.sentAt)
                            )
                        )
                    } catch {
                        //Crashlytics.crashlytics().log("Decryption failed for message id: \(id)")
                        //Crashlytics.crashlytics().record(error: error)
                    }
                case .connectedQuantity:
                    let quantity = try decoder.decode(ConnectionInfo_.self, from: data)
                    connectedUsers = quantity.count
                    if connectedUsers == 2 {
                        generateCryptoKeys()
                    }
                case .connectionId:
                    let id = try decoder.decode(ConnectedUser_.self, from: data).id
                    userId = id
                case .publicKeyMessage:
                    let publicKey = try decoder.decode(PublicKey_.self, from: data)
                    let sharedPublicKey = try PublicKey(rawRepresentation: publicKey.key)
                    do {
                        try cryptoKeysManager.updateOtherClientKey(sharedPublicKey)
                    } catch {
                        //Crashlytics.crashlytics().log("Failed to update other client key")
                        //Crashlytics.crashlytics().record(error: error)
                    }
                case .clearChat:
                    messages.removeAll()
                case .none:
                    break
                }
            } catch {
                //Crashlytics.crashlytics().log("Error decoding server responce")
                //Crashlytics.crashlytics().record(error: error)
            }
        case .none, .some(_):
            break
        }
    }
    
    public func sendMessage(_ message: String) async {
        guard let messageData = message.data(using: .utf8) else {
            return
        }
        do {
            let encryptedMessage = try cryptoKeysManager.encryptMessage(messageData)
            let taskMessage = URLSessionWebSocketTask.Message.string(encryptedMessage.base64EncodedString())
            try await webSocketTask?.send(taskMessage)
        } catch {
            //Crashlytics.crashlytics().log("Encryption failed in AES.GCM.seal")
            //Crashlytics.crashlytics().record(error: error)
        }
    }
    
    public func disconnect() {
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
    private func generateCryptoKeys() -> Result<Void, CryptoKeyManagerError> {
        guard let publicData = Data(base64Encoded: cryptoKeysManager
            .publicKey
            .rawRepresentation
            .base64EncodedString()
        ) else {
            return .failure(.encodePublicKey)
        }
        Task {
            await CryptoClient.shared.sendPublicKey(key: publicData, from: userId, to: peerUserId)
        }
        return .success(())
    }
}

extension WebSocketManager: URLSessionDelegate {
    
    public func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}

fileprivate struct WebSocketURLBuilder {
    
    static let baseURL = URL(string: "wss://localhost:8443")!
    
    static func makeURL(for path: String) -> URL {
        if path.hasPrefix("ws") {
            return URL(string: path)!
        } else {
            return baseURL.appendingPathComponent(path)
        }
    }
}
