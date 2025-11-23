//
//  MateClient.swift
//  Services
//
//  Created by setuper on 23.11.2025.
//

import Foundation
import Alamofire
import Network

private struct _MateStatus: Decodable {
    let status: String
}

public enum MateClient {
    
    public static func getStatus(for id: UUID) async throws -> String {
        let request = ApiRequest<Never>(
            method: .get,
            url: EndPoints_.users.appending("mate"),
            query: [
                "mate_id": "a3d68ac2-a9c7-4394-aff9-e883a2ec0378",
                "user_id": id
            ]
        )
        let result: ApiResponse<_MateStatus> = try await ApiClient.shared.perform(request: request)
        return result.body.status
    }
}
