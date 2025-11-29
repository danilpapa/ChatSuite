//
//  CryptoClient.swift
//  Services
//
//  Created by setuper on 23.11.2025.
//

import Foundation
import Alamofire
import Network
import API
import Singleton

@Singleton
public struct CryptoClient {
    
    public func sendPublicKey(key: Data, from id: String, to peerId: String) async {
        let request = ApiRequest(
            method: .post,
            url: EndPoints.publicKey.path,
            body: _PublicKeyData(
                id: id,
                peerId: peerId,
                publicKey: key.base64EncodedString()
            )
        )
        let _: ApiResponse<Never> = try! await ApiClient.shared.perform(request: request)
    }
}

private struct _PublicKeyData: Encodable {
    let id: String
    let peerId: String
    let publicKey: String
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case peerId = "peer_id"
        case publicKey = "public_key"
    }
}
