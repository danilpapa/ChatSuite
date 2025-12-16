//
//  PublicKey_.swift
//  ChatClient
//
//  Created by setuper on 17.09.2025.
//

import Foundation

public struct PublicKey_: Decodable {
    
    public let type: String = "public_key"
    public let key: Data
    
    public init(key: Data) {
        self.key = key
    }
}
