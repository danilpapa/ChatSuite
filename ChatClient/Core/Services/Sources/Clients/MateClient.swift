//
//  MateClient.swift
//  Services
//
//  Created by setuper on 23.11.2025.
//

import Foundation
import Alamofire
import Network
import Singleton
import API

@Singleton
public struct MateClient {
    
    public func getStatus(from id: UUID, to peerId: UUID) async throws -> String {
        let request = ApiRequest<Never>(
            method: .get,
            url: EndPoints.users.appending("mate"),
            query: [
                "mate_id": peerId,
                "user_id": id
            ]
        )
        let result: ApiResponse<_MateStatus> = try await ApiClient.shared.perform(request: request)
        return result.body.status
    }
}

private struct _MateStatus: Decodable {
    let status: String
}
