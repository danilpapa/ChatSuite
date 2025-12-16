//
//  ConnectedUser_.swift
//  ChatClient
//
//  Created by setuper on 16.09.2025.
//

import Foundation

public struct ConnectedUser_: Decodable {
    
    public let id: String
    
    public init(id: String) {
        self.id = id
    }
}
