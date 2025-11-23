//
//  ApiRequest.swift
//  HeedAssembly
//
//  Created by setuper on 23.11.2025.
//

import Foundation
import Alamofire

public struct ApiRequest<Body: Encodable>: URLConvertible, @unchecked Sendable {
    public typealias QueryParams = [String: Any]
    
    var method: HTTPMethod
    var url: String
    var headers: HTTPHeaders
    var query: QueryParams?
    var body: Body?
    
    public init(
        method: HTTPMethod,
        url: String,
        headers: HTTPHeaders = [.contentType("application/json")],
        query: QueryParams? = nil,
        body: Body? = nil
    ) {
        self.method = method
        self.url = url
        self.headers = headers
        self.query = query
        self.body = body
    }
    
    public func asURL() throws -> URL {
        guard let wrapped = URL(string: url) else {
            throw AFError.invalidURL(url: url)
        }
        return wrapped
    }
}
