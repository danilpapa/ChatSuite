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
    
    private init() { }
    
    func sendPublicKey(key: Data) -> Result<Void, ServerEndpointsError> {
//        let params: Parameters = [
//            "public_key": key
//        ]
//        AF.request(
//            EndPoints.publicKey.url,
//            method: .post,
//            parameters: params,
//            headers: nil
//        )
//        .validate(statusCode: 200 ..< 299).response { responce in
//            print(responce.result)
//            switch responce.result {
//            case let .success(data):
//                print(data)
//            case let .failure(error):
//                print(error.localizedDescription)
//            }
//        }
        return .success(())
    }
}
