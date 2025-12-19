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
}

#if DEBUG
#Preview {
    ChatClient()
}
#endif
