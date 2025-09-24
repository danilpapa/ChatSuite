//
//  MainVie4w.swift
//  ChatClient
//
//  Created by setuper on 20.09.2025.
//

import SwiftUI

struct MainView: View {
    var user: User
    // md 0TTAKXoKRLdlDMUdgxMQsE0sp462
    // dm YSXfM6v2OpRacZLjCD7g64BhUvT2
    let userId: String = "0TTAKXoKRLdlDMUdgxMQsE0sp462"
    let peerId: String = "YSXfM6v2OpRacZLjCD7g64BhUvT2"
    
    var body: some View {
        NavigationLink {
            ChatView(socketManager: WebSocketManager(cryptoKeysManager: CryptoManager(), userId: userId, peerId: peerId))
        } label: {
            Text("Chat \(userId)")
        }
        .onAppear {
            print(user.id)
        }
    }
}
