//
//  SearchMateView.swift
//  ChatClient
//
//  Created by setuper on 10.10.2025.
//

import SwiftUI
import API
import Services

struct SearchMateView: View {
    @StateObject private var router = Router()
    @State private var isFetchingMateStatus = false
    @State private var mateStatus: MateStatus?
    
    private var user: User
    private var displayedUsers: [User]
    
    init(user: User, displayedUsers: [User]) {
        self.user = user
        self.displayedUsers = displayedUsers
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack {
                List {
                    ForEach(displayedUsers) { mate in
                        Text(mate.email)
                            .onTapGesture {
                                Task {
                                    await getMateStatus(from: user.id, mate: mate.id)
                                }
                            }
                            .sheet(item: $mateStatus) { _ in
                                MateStatusPageView(
                                    user: user,
                                    mate: mate,
                                    mateStatus: $mateStatus
                                )
                            }
                    }
                }
            }
            .overlay {
                Text("No recent mates")
                    .opacity(displayedUsers.isEmpty ? 1 : 0)
                ProgressView()
                    .opacity(isFetchingMateStatus ? 1 : 0)
            }
        }
        .navigationDestination(for: AppRoutes.self) { $0.destination }
        .navigationTitle("Search Mate")
    }
    
    private func getMateStatus(from: UUID, mate: UUID) async {
        do {
            defer { isFetchingMateStatus = false }
            isFetchingMateStatus = true
            guard let response = try await MateClient.shared.getStatus(from: from, to: mate) else {
                // handle
                return
            }
            mateStatus = response
        } catch {
            print(#file)
            print(error.localizedDescription)
        }
    }
}
