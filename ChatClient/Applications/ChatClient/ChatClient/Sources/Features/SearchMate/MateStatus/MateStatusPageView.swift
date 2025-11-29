//
//  MateStatusPageView.swift
//  ChatClient
//
//  Created by setuper on 15.11.2025.
//

import SwiftUI
import API
import Services

struct MateStatusPageView: View {
    @State private var isFetchingMateStatus = false
    private var user: User
    private var mate: User
    @State private var mateStatus: String = ""
    var mateClient: IMateClient
    
    init(
        user: User,
        mate: User,
        mateClient: IMateClient
    ) {
        self.user = user
        self.mate = mate
        self.mateClient = mateClient
    }
    
    var body: some View {
        VStack {
            Text("Mate")
                .font(.headline)
                .fontWeight(.semibold)
            HStack {
                Text(mate.email)
            }
            Button {
                Task {
                    // TODO: work here
                    if mateStatus == "Add mate" {
                        do {
                            try await UserClient.friendRequestAction("Add mate", from: user.id, to: mate.id)
                            await loadStatus()
                        }
                    }
                }
            } label: {
                Text(mateStatus)
                    .foregroundStyle(.background)
                    .padding(10)
                    .background(
                        Color.green,
                        in: .capsule
                    )
                    .overlay {
                        ProgressView()
                            .opacity(isFetchingMateStatus ? 1 : 0)
                    }
            }
        }
        .task {
            await loadStatus()
        }
    }
    
    private func loadStatus() async {
        defer { isFetchingMateStatus = false }
        isFetchingMateStatus = true
        do {
            mateStatus = try await mateClient.getStatus(from: user.id, to: mate.id)
        } catch {
            print(#file)
            print(error.localizedDescription)
        }
    }
}
