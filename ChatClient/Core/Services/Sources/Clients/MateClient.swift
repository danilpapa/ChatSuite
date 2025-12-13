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
    
    public func getStatus(from id: UUID, to peerId: UUID) async throws -> MateStatus? {
        let request = ApiRequest<Never>(
            method: .get,
            url: EndPoints.users.appending("mate"),
            query: [
                "mate_id": peerId,
                "user_id": id
            ]
        )
        let result: ApiResponse<_MateStatus> = try await ApiClient.shared.perform(request: request)
        guard let mateStatus = MateStatus(rawValue: result.body.status) else {
            print(#file)
            return nil
        }
        return mateStatus
    }
}

private struct _MateStatus: Decodable {
    let status: String
}
