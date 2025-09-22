//
//  MainVie4w.swift
//  ChatClient
//
//  Created by setuper on 20.09.2025.
//

import SwiftUI

struct MainView: View {
    let userId: UUID = .generate(1)
    let peerId: UUID = .generate(2)
    
    var body: some View {
        NavigationStack {
            NavigationLink {
                ChatView(socketManager: WebSocketManager(cryptoKeysManager: CryptoManager(), userId: userId, peerId: peerId))
            } label: {
                Text("Chat \(userId.uuidString.dropFirst().string)")
            }
        }
    }
}

public extension UUID {
    
    static func generate(_ val: Int) -> Self {
        UUID(uuidString: "\(val)\(val)\(val)\(val)\(val)\(val)\(val)\(val)-\(val)\(val)\(val)\(val)-\(val)\(val)\(val)\(val)-\(val)\(val)\(val)\(val)-\(val)\(val)\(val)\(val)\(val)\(val)\(val)\(val)\(val)\(val)\(val)\(val)")!
    }
}

public extension Substring {
    
    var string: String {
        return String(self)
    }
}
