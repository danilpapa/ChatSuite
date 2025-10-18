//
//  BaseURLInterceptor.swift
//  ChatClient
//
//  Created by setuper on 18.10.2025.
//

import Foundation
import Alamofire

final class BaseURLInterceptor: RequestInterceptor {
    
    private let baseURL: URL
    
    init(baseURL: URL = URL(string: "https://localhost:8443")!) {
        self.baseURL = baseURL
    }
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, any Error>
    ) -> Void) {
        guard let url = urlRequest.url else {
            completion(.success(urlRequest))
            return
        }
        
        if url.absoluteString.hasPrefix("http") || url.absoluteString.hasPrefix("wss") {
            completion(.success(urlRequest))
            return
        }
        
        var newRequest = urlRequest
        let newURL = baseURL.appendingPathComponent(url.relativeString)
        newRequest.url = newURL
        
        completion(.success(newRequest))
    }
}
