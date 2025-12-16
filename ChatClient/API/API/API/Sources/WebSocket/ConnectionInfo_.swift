//
//  ConnectionInfo_.swift
//  ChatClient
//
//  Created by setuper on 13.09.2025.
//

import Foundation

public struct ConnectionInfo_: Decodable {
    
    public let count: Int
    
    public init(count: Int) {
        self.count = count
    }
}
