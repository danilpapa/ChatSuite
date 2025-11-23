//
//  ApiResponse.swift
//  API
//
//  Created by setuper on 23.11.2025.
//

import Foundation
import Alamofire

public struct ApiResponse<Body: Decodable> {
    
    public init(status: NetworkStatus, headers: HTTPHeaders, body: Body) {
        self.status = status
        self.headers = headers
        self.body = body
    }
    
    public var status: NetworkStatus
    public var headers: HTTPHeaders
    public var body: Body
}

public struct NetworkStatus {
    
    public init(code: Int, description: String) {
        self.code = code
        self.description = description
    }
    
    public let code: Int
    public let description: String
}

