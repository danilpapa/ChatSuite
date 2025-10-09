//
//  WebSocketManager.swift
//  ChatClient
//
//  Created by setuper on 13.09.2025.
//

import Foundation
import SwiftUI
import FirebaseCrashlytics

@Observable
final class WebSocketManager: NSObject {
    
    var userId: String
    var peerUserId: String
    
    var connectedUsers: Int = 0
    var messages: [MessageModel] = []

    private var webSocketTask: URLSessionWebSocketTask?
    private var cryptoKeysManager: ICryptoManager
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    init(cryptoKeysManager: ICryptoManager, userId: String, peerId: String) {
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
                Crashlytics.crashlytics().log("WebSocket receive failed")
                Crashlytics.crashlytics().record(error: error)
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
                        Crashlytics.crashlytics().log("Error decoding base64 from chatMessage.text")
                        Crashlytics.crashlytics().record(error: CryptoKeyManagerError.invalidDecryptedData)
                        return
                    }
                    let id = chatMessage.senderId,
                        decryptedResult = cryptoKeysManager.decryptMessage(encryptedData)
                    switch decryptedResult {
                    case let .success(decryptedMessage):
                        messages.append(
                            MessageModel(
                                text: decryptedMessage,
                                isYour: id == userId,
                                sentAt: dateFormatter.string(from: chatMessage.sentAt)
                            )
                        )
                    case let .failure(error):
                        Crashlytics.crashlytics().log("Decryption failed for message id: \(id)")
                        Crashlytics.crashlytics().record(error: error)
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
                        Crashlytics.crashlytics().log("Failed to update other client key")
                        Crashlytics.crashlytics().record(error: error)
                    }
                case .clearChat:
                    messages.removeAll()
                case .none:
                    break
                }
            } catch {
                Crashlytics.crashlytics().log("Error decoding server responce")
                Crashlytics.crashlytics().record(error: error)
            }
        case .none, .some(_):
            break
        }
    }
    
    func sendMessage(_ message: String) async {
        guard let messageData = message.data(using: .utf8) else {
            return
        }
        do {
            let encryptedMessageResult = cryptoKeysManager.encryptMessage(messageData)
            switch encryptedMessageResult {
            case let .success(encryptedMessage):
                let taskMessage = URLSessionWebSocketTask.Message.string(encryptedMessage.base64EncodedString())
                try await webSocketTask?.send(taskMessage)
            case .failure(let error):
                Crashlytics.crashlytics().log("Encryption failed in AES.GCM.seal")
                Crashlytics.crashlytics().record(error: error)
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
    private func generateCryptoKeys() -> Result<Void, CryptoKeyManagerError> {
        guard let publicData = Data(base64Encoded: cryptoKeysManager
            .publicKey
            .rawRepresentation
            .base64EncodedString()
        ) else {
            return .failure(.encodePublicKey)
        }
        Task {
            await NetworkManager.shared.sendPublicKey(
                key: publicData,
                from: userId,
                to: peerUserId
            )
        }
        return .success(())
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
