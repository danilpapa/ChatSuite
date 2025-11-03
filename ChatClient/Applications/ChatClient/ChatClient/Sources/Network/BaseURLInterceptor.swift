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
        let updatedString = url.relativeString.replacingOccurrences(of: "%3F", with: "?")
        print(updatedString)
        let newURL = baseURL.appendingPathComponent(updatedString)
        newRequest.url = newURL
        
        if let url = newRequest.url {
            print("Запрос: \(url.absoluteString)")
        }
        
        completion(.success(newRequest))
    }
}
