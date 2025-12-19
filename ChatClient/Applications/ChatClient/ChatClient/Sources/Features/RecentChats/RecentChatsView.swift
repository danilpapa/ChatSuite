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
    @Environment(\.heed) var heed
    
    @State private var activeFriends: [User] = []
    @State private var isFetchingRequest: Bool = false
    
    @StateObject private var pushNotificationManager: PushNotificationManager
        
    init(pushNotificationManager: PushNotificationManager) {
        self._pushNotificationManager = StateObject(wrappedValue: pushNotificationManager)
        Task.detached { [self] in
            await connect()
        }
    }
    
    var body: some View {
        Group {
            List {
                ForEach(activeFriends) { friend in
                    UserView(user: friend)
                        .onTapGesture {
                            router.push(.chat(
                                heed
                                    .webSocketComponent
                                    .makeWebSocketManager(
                                        userId: appState.user.id,
                                        peerId: friend.id
                                    )
                            ))
                        }
                }
                .padding()
                .listRowSeparator(.hidden)
                .background(.ultraThinMaterial, in: .capsule)
            }
            .background(.white)
            .presentationDetents([.medium])
            .listStyle(.plain)
            .listRowBackground(Color.clear)
            .onChange(of: pushNotificationManager.incomingRequest) { _, newValue in
                if let newValue {
                    Task {
                        do {
                            let chatMateName = try await UserClient.shared.userName(for: newValue.peerId)
                            guard let peerId = UUID(uuidString: newValue.peerId) else { return }
                            appState.mateToChat = .init(id: peerId, email: chatMateName)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            .refreshable {
                Task {
                    await fetchFriends()
                }
            }
            .overlay {
                Image(systemName: "person.crop.circle.fill.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.ultraThinMaterial)
                    .rotationEffect(.degrees(18))
                    .frame(height: 250)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .foregroundStyle(.background)
                            .overlay {
                                VStack {
                                    Text("You have no friends")
                                        .foregroundStyle(.gray.opacity(0.75))
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                    Text("Let's change it!")
                                        .foregroundStyle(.gray.opacity(0.75))
                                        .font(.title3)
                                }
                            }
                            .frame(height: 75)
                    }
                    .opacity(isFetchingRequest && activeFriends.isEmpty ? 1 : 0)
            }
        }
        .task {
            await fetchFriends()
        }
    }
    
    @MainActor
    private func fetchFriends() async {
        isFetchingRequest = true
        defer { isFetchingRequest = false }
        do {
            activeFriends = try await UserClient.shared.activeFriends(for: appState.user)
        } catch {
            print(error.localizedDescription)
            print(#file)
        }
    }
    
    private func connect() async {
        pushNotificationManager.connect()
    }
}

#if DEBUG
#Preview {
    ChatClient()
}
#endif
