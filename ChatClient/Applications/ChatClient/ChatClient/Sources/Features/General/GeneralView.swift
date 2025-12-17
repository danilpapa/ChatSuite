//
//  GeneralView.swift
//  ChatClient
//
//  Created by setuper on 30.11.2025.
//

import SwiftUI
import API
import Services

struct GeneralView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var router = Router()
    @State private var isFriendRequestViewPresented: Bool = false
    
    var body: some View {
        NavigationStack(path: $router.path) {
            RecentChatsView()
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            isFriendRequestViewPresented = true
                        } label: {
                            Image(systemName: "person.checkmark.and.xmark")
                                .foregroundStyle(.background)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 12)
                        }
                        .glassEffect(.clear.tint(.accentColor))
                    }
                }
                .navigationDestination(for: AppRoutes.self) {
                    $0.destination
                        .environmentObject(router)
                }
                .sheet(isPresented: $isFriendRequestViewPresented) {
                    FriendRequestsView(for: appState.user)
                        .presentationDetents([.medium])
                }
                .navigationTitle("FireChat")
                .environmentObject(router)
        }
    }
}

fileprivate struct FriendRequestsView: View {
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
                VStack {
                    Image(systemName: "sharedwithyou")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                        .foregroundStyle(.green.opacity(0.9))
                        .shadow(color: .green, radius: 5)
                    Text("You have no active friend requests")
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


#if DEBUG
#Preview {
    ChatClient()
}
#endif
