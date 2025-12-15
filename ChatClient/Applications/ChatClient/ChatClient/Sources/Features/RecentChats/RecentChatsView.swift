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
    @State private var isSingleChatAlertPresented: Bool = false
    
    var body: some View {
        VStack {
            Text("Start chatting now")
                .foregroundStyle(.gray)
                .font(.callout)
            Button {
                if appState.mateToChat == nil {
                    isMateSelectionPresented = true
                } else {
                    isSingleChatAlertPresented = true
                }
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
                isPresented: $isMateSelectionPresented
            )
            .environmentObject(appState)
            .environmentObject(router)
        }
        .alert(
            "Ooops",
            isPresented: $isSingleChatAlertPresented
        ) {
            Button("Would you like to cancel it?", role: .destructive) {
                // TODO: cancel
            }
            Button("Ok", role: .cancel) { }
        } message: {
            Text("You already have an active chat request")
        }
    }
}

fileprivate struct MateSelectionView: View {
    @EnvironmentObject private var router: Router
    @EnvironmentObject var appState: AppState
    @State private var activeFriends: [User] = []
    @State private var isFetchingRequest: Bool = false
    
    @Binding private var isPresented: Bool
    
    fileprivate init(
        isPresented: Binding<Bool>,
    ) {
        self._isPresented = isPresented
    }
    
    var body: some View {
        Group {
            List {
                ForEach(activeFriends) { friend in
                    Text(friend.email)
                        .onTapGesture {
                            appState.mateToChat = friend
                            //router.push(.chat(WebSocketManager(cryptoKeysManager: CryptoManager(), userId: appState.user.id.uuidString, peerId: friend.id.uuidString)))
                            isPresented = false
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
                activeFriends = try await UserClient.shared.activeFriends(for: appState.user)
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
