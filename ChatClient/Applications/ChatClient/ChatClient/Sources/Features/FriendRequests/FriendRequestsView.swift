//
//  FriendRequestsView.swift
//  ChatClient
//
//  Created by setuper on 24.11.2025.
//

import SwiftUI
import API
import Services

struct FriendRequestsView: View {
    @State private var requests: [User] = []
    @State private var isFetchingRequest = false
    private let user: User
    
    init(for user: User) {
        self.user = user
    }
    
    var body: some View {
        List {
            ForEach(requests) { friendRequest in
                VStack {
                    Text(friendRequest.email)
                    HStack {
                        Button("Accept") {
                            Task {
                                do {
                                    try await UserClient.friendRequestAction("Accept", from: user.id, to: friendRequest.id)
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                        .buttonStyle(.glassProminent)
                        .tint(.blue)
                        
                        Button("Discard") {
                            Task {
                                do {
                                    try await UserClient.friendRequestAction("Discard", from: user.id, to: friendRequest.id)
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                        .buttonStyle(.glassProminent)
                        .tint(.red)
                    }
                }
            }
        }
        .refreshable {
            await loadData()
        }
        .overlay {
            if requests.isEmpty && !isFetchingRequest {
                Text("No actual friend request")
            }
            if isFetchingRequest {
                ProgressView()
            }
        }
        .task {
            isFetchingRequest = true
            defer { isFetchingRequest = false }
            await loadData()
        }
    }
    
    private func loadData() async {
        do {
            requests = try await UserClient.actualFriendRequests(for: user)
        } catch {
            print(error.localizedDescription)
            print(#file)
        }
    }
}
