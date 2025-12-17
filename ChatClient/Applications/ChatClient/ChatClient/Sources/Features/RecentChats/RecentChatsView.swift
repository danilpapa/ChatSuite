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
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var router: Router
    @State private var isMateSelectionPresented = false
    
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
            MateSelectionView(
                for: appState.user,
                isPresented: $isMateSelectionPresented
            )
        }
    }
}

fileprivate struct MateSelectionView: View {
    @EnvironmentObject private var router: Router
    @Environment(\.heed) var heed
    @EnvironmentObject var appState: AppState
    
    @State private var activeFriends: [User] = []
    @State private var isFetchingRequest: Bool = false
    
    private var user: User
    @Binding private var isPresented: Bool
    
    fileprivate init(
        for user: User,
        isPresented: Binding<Bool>,
    ) {
        self.user = user
        self._isPresented = isPresented
    }
    
    var body: some View {
        Group {
            List {
                ForEach(activeFriends) { friend in
                    Text(friend.email)
                        .onTapGesture {
                            isPresented = false
                            appState.mateToChat = friend
                            router.push(.chat(
                                heed
                                    .webSocketComponent
                                    .makeWebSocketManager(
                                        userId: user.id,
                                        peerId: friend.id
                                    )
                            ))
                        }
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
            } catch {
                print(error.localizedDescription)
                print(#file)
            }
        }
    }
}

#if DEBUG
#Preview {
    ChatClient()
}
#endif
