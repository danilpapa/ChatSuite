//
//  ApiResponse_.swift
//  HeedAssembly
//
//  Created by setuper on 23.11.2025.
//

import Foundation
import Alamofire

public struct ApiResponse<Body: Decodable> {
    
    public var status: NetworkStatus
    public var headers: HTTPHeaders
    public var body: Body
}

public struct NetworkStatus {
    
    public let code: Int
    public let description: String
}
