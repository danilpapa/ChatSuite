//
//  WebSocketManager.swift
//  ChatClient
//
//  Created by setuper on 13.09.2025.
//

import Foundation
import Alamofire
import CryptoKit

typealias CryptoPrivate = Curve25519.KeyAgreement.PrivateKey
typealias CryptoPublic = Curve25519.KeyAgreement.PrivateKey.PublicKey

struct CryptoKey {
    
    private var privateKey: CryptoPrivate?
    private var publicKey: CryptoPublic?
    private var otherClientKey: CryptoPublic?
    
    mutating func updatePrivateKey(_ key: CryptoPrivate) -> (CryptoPrivate, CryptoPublic) {
        privateKey = key
        publicKey = key.publicKey
        return (key, key.publicKey)
    }
    
    mutating func updateOtherClientKey(_ key: CryptoPublic) -> CryptoPublic {
        otherClientKey = key
        return key
    }
}

@Observable
final class WebSocketManager: NSObject {
    
    var messages: [String] = []
    var connectedCount: Int = 0
    private var webSocketTask: URLSessionWebSocketTask?
    private var cryptoKey = CryptoKey()
    
    func connect() {
        let session = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: .main
        )
        webSocketTask = session.webSocketTask(with: EndPoints.chatUrl.url)
        webSocketTask?.resume()
        
        Task {
            await receiveMessages()
        }
    }
    
    private func receiveMessages() async {
        while webSocketTask?.state == .running {
            do {
                let result = try await webSocketTask?.receive()
                switch result {
                case let .data(data):
                    let decoder = JSONDecoder()
                    do {
                        let messageType = try decoder.decode(ServerMessagesType.self, from: data)
                        switch MessageType(rawValue: messageType.type) {
                        case .chatMessage:
                            let chatMessage = try decoder.decode(ChatMessage.self, from: data)
                            self.messages.append(chatMessage.text)
                            break
                        case .connectedQuantity:
                            let quantity = try decoder.decode(ConnectionMessage.self, from: data)
                            self.connectedCount = quantity.count
                            if connectedCount == 1 { // TODO: Swap to == 2
                               let result = generateCryptoKeys()
                                switch result {
                                case .success(()):
                                    break
                                case let .failure(error):
                                    // handle error
                                    print(error)
                                }
                            }
                        case .clearChat:
                            self.messages.removeAll()
                        default:
                            break
                        }
                    } catch {
                        // handle
                    }
                case .string(_):
                    // Handle string
                    print()
                    break
                default:
                    break
                }
            } catch {
                print("Receive error: \(error)")
                break
            }
        }
    }
    
    func sendMessage(_ message: String) async throws {
        let message = """
        {
            "type": "text_message",
            "message": \(message)
        }
        """
        let taskMessage = URLSessionWebSocketTask.Message.string(message)
        try await webSocketTask?.send(taskMessage)
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: "Some reason".data(using: .utf8))
        DispatchQueue.main.async {
            self.messages.removeAll()
        }
    }
    
    private func generateCryptoKeys() -> Result<Void, ServerEndpointsError> {
        let keys: (privateKey: CryptoPrivate, publicKey: CryptoPublic) = cryptoKey.updatePrivateKey(Curve25519.KeyAgreement.PrivateKey())
        guard let publicData = Data(base64Encoded: keys.publicKey.rawRepresentation.base64EncodedString()) else {
            return .failure(.encodePublicKey)
        }
        Task {
            await NetworkManager.shared.sendPublicKey(key: publicData)
        }
        return .success(())
    }
}

extension WebSocketManager: URLSessionDelegate {
    
    /// Only in DEBUG!
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}
