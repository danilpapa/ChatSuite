//
//  ActiveFriendsView.swift
//  ChatClient
//
//  Created by setuper on 30.11.2025.
//

import SwiftUI
import API
import Services

struct ActiveFriendsView: View {
    @State private var friendName: String = ""
    @State private var activeFriends: [User] = []
    
    var user: User
    
    var body: some View {
        VStack {
            Color.white
        }
        .overlay(alignment: .top) {
            TextField("Search friend", text: $friendName)
                .opacity(activeFriends.isEmpty ? 0 : 1)
        }
        .overlay(alignment: .center) {
            Text("No active friends")
                .opacity(activeFriends.isEmpty ? 1 : 0)
        }
        .task {
            do {
                activeFriends = try await UserClient.shared.activeFriends(for: user)
            } catch {
                print(error.localizedDescription)
                print(#file)
            }
        }
    }
}
