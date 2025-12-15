//
//  RecentChatsView.swift
//  ChatClient
//
//  Created by setuper on 16.10.2025.
//

import SwiftUI
import API
import Services

struct RecentChatsView: View {
    @EnvironmentObject var router: Router
    @State private var isMateSelectionPresented = false
    
    private var user: User
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        VStack {
            Text("Start chatting now")
                .foregroundStyle(.gray)
                .font(.callout)
            Button {
                isMateSelectionPresented = true
            } label: {
                Image(systemName: "plus.message.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                    .foregroundStyle(.blue)
                    .glassEffect()
            }
        }
        .sheet(isPresented: $isMateSelectionPresented) {
            MateSelectionView(user: user)
        }
    }
}

fileprivate struct MateSelectionView: View {
    @State private var activeFriends: [User] = []
    @State private var isFetchingRequest: Bool = false
    private var user: User
    
    fileprivate init(user: User) {
        self.user = user
    }
    
    var body: some View {
        Group {
            List {
                ForEach(activeFriends) { friend in
                    Text(friend.email)
                }
            }
            .overlay {
                ZStack {
                    Color.gray.opacity(0.3)
                    ProgressView()
                }
                .opacity(isFetchingRequest ? 1 : 0)
            }
        }
        .task {
            isFetchingRequest = true
            defer { isFetchingRequest = false }
            do {
                activeFriends = try await UserClient.shared.activeFriends(for: user)
                print(activeFriends)
            } catch {
                print(error.localizedDescription)
                print(#file)
            }
        }
    }
}
