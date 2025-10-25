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
        session = Session(interceptor: BaseURLInterceptor(), serverTrustManager: manager)
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
    
    func login(with credentials: GoogleCredentials_) async throws(NetworkError) -> UUID {
        let params: [String: Any] = [
            "user_email": credentials.email,
            "firebase_token": credentials.firebaseToken
        ]
        do {
            let response = try await session.request(
                EndPoints.login.path,
                method: .post,
                parameters: params,
                encoding: JSONEncoding.default
            ).serializingString().value
            
            if let loggedUserId = UUID(uuidString: response) {
                return loggedUserId
            } else {
                throw NetworkError.loginError("Invalid user ID received: \(response)")
            }
        } catch {
            throw NetworkError.loginRequest("Error via sending request: \(error.localizedDescription)")
        }
    }
    
    func obtainUsers(email: String) async throws -> [User] {
        do {
            let params: [String: Any] = [
                "user_name_prefix": email
            ]
            return try await session.request(
                EndPoints.users.path,
                method: .get,
                parameters: params,
                encoding: URLEncoding.default
            )
            .serializingDecodable([User].self)
            .value
        } catch {
            throw NetworkError.obtainingUsersError(error.localizedDescription)
        }
    }
    
    func obtainRecentChats(for userId: UUID) async throws -> [RecentChat] {
        do {
            let params: [String: Any] = [
                "user_id": userId.uuidString
            ]
            let responce = try await session.request(
                EndPoints.recentChats.path,
                method: .post,
                parameters: params,
                encoding: JSONEncoding.default,
            ).serializingString().value
            print(responce)
            return []
        } catch {
            print(error.localizedDescription)
            throw NetworkError.obtainingUsersError(error.localizedDescription)
        }
    }
}
