//
//  PushNotificationManager.swift
//  ChatClient
//
//  Created by setuper on 19.12.2025.
//

import API
import Foundation

public final class PushNotificationManager: NSObject, ObservableObject {
    
    private var userId: String
    private var webSocketTask: URLSessionWebSocketTask?
    @Published public var incomingRequest: _IncomingChatRequest?
    
    public init(userId: UUID) {
        self.userId = userId.uuidString
    }
    
    @MainActor
    public func connect() {
        let session = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: .main
        )
        let url = URL(string: "wss://localhost:8443/connect")!
        var request = URLRequest(url: url)
        
        request.setValue(userId, forHTTPHeaderField: "user_id")
        
        webSocketTask = session.webSocketTask(with: request)
        webSocketTask?.resume()
        
        Task {
            await receiveMessages()
        }
    }
    
    @MainActor
    private func receiveMessages() async {
        while webSocketTask?.state == .running {
            do {
                let result = try await webSocketTask?.receive()
                handleWebSocketResult(result)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    private func handleWebSocketResult(_ result: URLSessionWebSocketTask.Message?) {
        switch result {
        case let .data(data):
            let decoder = JSONDecoder()
            do {
                let incomingRequest = try decoder.decode(_IncomingChatRequest.self, from: data)
                self.incomingRequest = incomingRequest
            } catch {
                print(error.localizedDescription)
            }
        case .none, .some(_):
            break
        }
    }
}

extension PushNotificationManager: URLSessionDelegate {
    
    public func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        completionHandler(
            .useCredential,
            URLCredential(
                trust: challenge.protectionSpace.serverTrust!)
        )
    }
}

public struct _IncomingChatRequest: Decodable, Equatable {
    
    let peerId: String
    let hostId: String
    
    enum CodingKeys: String, CodingKey {
        case peerId = "peer_id"
        case hostId = "host_id"
    }
}
