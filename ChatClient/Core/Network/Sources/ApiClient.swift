//
//  ApiClient.swift
//  HeedAssembly
//
//  Created by setuper on 23.11.2025.
//

import Foundation
import Alamofire
import API

public actor ApiClient {
    
    public static let shared = ApiClient()
    private var session = Session(serverTrustManager: ServerTrustManager(evaluators: ["localhost": DisabledTrustEvaluator()]))
    
    private init() { }
    
    public func perform<RequestBody: Encodable, ResponseBody: Decodable>(
        request: ApiRequest<RequestBody>
    ) async throws -> ApiResponse<ResponseBody> {
        let networkResponse = await session.request(
            request,
            method: request.method,
            parameters: request.query,
            encoding: URLEncoding(destination: .queryString),
            headers: request.headers,
            requestModifier: { urlRequest in
                if let body = request.body {
                    urlRequest.httpBody = try JSONEncoder().encode(body)
                }
            }
        )
        .serializingDecodable(ResponseBody.self)
        .response
        guard let respose = networkResponse.response else {
            throw AFError.responseValidationFailed(reason: .dataFileNil)
        }
        switch networkResponse.result {
        case let .success(result):
            return ApiResponse(
                status: NetworkStatus(
                    code: respose.statusCode,
                    description: respose.description
                ),
                headers: respose.headers,
                body: result
            )
        case let .failure(error):
            throw error
        }
    }
}
