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
    @EnvironmentObject private var router: Router
    @State private var requests: [User] = []
    @State private var isFetchingRequest = false
    @State private var isShownMatePage = false
    private let user: User
    
    init(for user: User) {
        self.user = user
    }
    
    var body: some View {
        List {
            ForEach(requests) { friendRequest in
                VStack {
                    Text(friendRequest.email)
                        .onTapGesture {
                            isShownMatePage = true
                        }
                        .sheet(isPresented: $isShownMatePage) {
                            MateStatusPageView(
                                user: user,
                                mate: friendRequest,
                                mateStatus: .expectation,
                                onClose: {
                                    isShownMatePage = false
                                    Task {
                                        await fetchActualRequests()
                                    }
                                }
                            )
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
            await fetchActualRequests()
        }
    }
    
    private func fetchActualRequests() async {
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
