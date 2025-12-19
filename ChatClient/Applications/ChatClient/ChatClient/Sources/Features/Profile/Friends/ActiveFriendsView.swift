//
//  ActiveFriendsView.swift
//  ChatClient
//
//  Created by setuper on 30.11.2025.
//

import SwiftUI
import API
import Services

struct ActiveFriendsView: View {
    @State private var isFetchingRequest: Bool = false
    @State private var activeFriends: [User] = []
    
    private let user: User
    
    init(for user: User) {
        self.user = user
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(activeFriends) { friend in
                    UserView(user: friend)
                        .listRowBackground(Color.clear)
                        .scrollContentBackground(.hidden)
                }
            }
            .padding(.top, 35)
            .padding(.horizontal)
        }
        .overlay {
            if activeFriends.isEmpty && !isFetchingRequest {
                VStack {
                    Image(systemName: "shareplay.slash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                        .foregroundStyle(.blue.opacity(0.9))
                        .shadow(color: .blue, radius: 5)
                    Text("You have no active friends")
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                }
            }
            if isFetchingRequest {
                ProgressView()
            }
        }
        .task {
            await fetchActualFriends()
        }
        .presentationDetents([.medium])
        .presentationBackground(.clear)
    }
    
    private func fetchActualFriends() async {
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

#if DEBUG
#Preview {
    ChatClient()
}
#endif
