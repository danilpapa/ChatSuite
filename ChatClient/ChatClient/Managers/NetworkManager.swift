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
}
