//
//  NetworkManager.swift
//  ChatClient
//
//  Created by setuper on 14.09.2025.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    private let MAYBACHDanil = "a3d68ac2-a9c7-4394-aff9-e883a2ec0378"
    
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
            EndPoints.publicKey.path,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default
        ).response { _ in }
    }
    
    func obtainRecentChats(for userId: UUID) async throws -> [RecentChat] {
        do {
            let params: [String: Any] = ["user_id": userId.uuidString]
            let responce = try await session.request(
                EndPoints.recentChats.path,
                method: .post,
                parameters: params,
                encoding: JSONEncoding.default
            ).serializingString().value
            print(responce)
            return []
        } catch {
            print(error.localizedDescription)
            throw NetworkError.obtainingUsersError(error.localizedDescription)
        }
    }
    
    func mateRequest(to id: UUID, status: String) async {
        let bodyParams: [String: Any] = [
            "request_status": status,
            "user_id": MAYBACHDanil,
            "peer_id": id
        ]
        do {
            let result = try await session.request(
                EndPoints.users.appending("mate"),
                method: .post,
                parameters: bodyParams
            )
            .serializingString()
            .value
        } catch {
            print(error.localizedDescription)
        }
    }
}
