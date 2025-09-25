//
//  MainVie4w.swift
//  ChatClient
//
//  Created by setuper on 20.09.2025.
//

import SwiftUI

struct MainView: View {
    var user: User
    
    let userId: String = "YSXfM6v2OpRacZLjCD7g64BhUvT2"
    let peerId: String = "0TTAKXoKRLdlDMUdgxMQsE0sp462"
    
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
