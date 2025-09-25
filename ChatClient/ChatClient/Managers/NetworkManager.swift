//
//  NetworkManager.swift
//  ChatClient
//
//  Created by setuper on 14.09.2025.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    static let shared: NetworkManager = .init()
    private var session: Session
    
    private init() {
        let manager = ServerTrustManager(evaluators: [
            "localhost": DisabledTrustEvaluator()
        ])
        session = Session(serverTrustManager: manager)
    }
    
    func sendPublicKey(key: Data, from id: String, to peerId: String) async {
        let params: [String: Any] = [
            "user_id": id,
            "peer_id": peerId,
            "public_key": key.base64EncodedString()
        ]
        session.request(
            EndPoints.publicKey.url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default
        ).response { response in
            // print(response.result)
        }
    }
    
    func sendLoggedEmail(_ email: String) async -> Result<UUID, NetworkError> {
        let params: [String: Any] = [
            "user_email": email
        ]
        do {
            let responce = try await session.request(
                EndPoints.email.url,
                method: .post,
                parameters: params,
                encoding: JSONEncoding.default
            ).serializingDecodable(UserIdResponse.self).value
            return .success(UUID(uuidString: responce.id)!)
        } catch {
            print("Logging error: \(error.localizedDescription)")
            return .failure(.incorrectEmail)
        }
    }
}

enum NetworkError: Error {
    
    case incorrectEmail
}
