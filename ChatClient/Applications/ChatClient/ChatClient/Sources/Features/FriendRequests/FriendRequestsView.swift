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
                            
                        }
                        .buttonStyle(.glass)
                        
                        Button("Discard") {
                            
                        }
                        .tint(.red)
                        .buttonStyle(.glass)
                    }
                }
            }
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
            do {
                requests = try await UserClient.shared.actualFriendRequests(for: user)
            } catch {
                print(error.localizedDescription)
                print(#file)
            }
        }
    }
}
