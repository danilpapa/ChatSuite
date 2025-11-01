//
//  PublicKey_.swift
//  ChatClient
//
//  Created by setuper on 17.09.2025.
//

import Foundation

struct PublicKey_: Decodable {
    
    let type: String = "public_key"
    let key: Data
}
