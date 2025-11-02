//
//  SearchMateView.swift
//  ChatClient
//
//  Created by setuper on 10.10.2025.
//

import SwiftUI

// TODO: Cache
final class SearchMateViewModel: ObservableObject {
    
    @Published var mateName: String = ""
    @Published var mateStatus: String = ""
    @Published var isFetchingUsers = false
    @Published var isFetchingMateStatus = false
    @Published var loadedUsers: [User] = []
    @Published var isInviteSheetPresented: Bool = false {
        didSet {
            if !isInviteSheetPresented {
                mateToInvite = nil
            }
        }
    }
    var mateToInvite: User?
    
    init() { }
    
    func search() async {
        do {
            self.isFetchingUsers = true
            let obtainedUsers = try await NetworkManager.shared.obtainUsersByNamePrefix(email: mateName)
            self.isFetchingUsers = false
            if loadedUsers != obtainedUsers {
                Main {
                    self.loadedUsers = obtainedUsers
                }
            }
        } catch {
            print(error.localizedDescription)
            self.isFetchingUsers = false
        }
    }
    
    func getMateStatus() async {
        guard let user = mateToInvite else { fatalError("WTF") }
        do {
            self.isFetchingMateStatus = true
            let status = try await NetworkManager.shared.getMateStatus(for: user.id)
            Main {
                self.mateStatus = status
            }
            self.isFetchingMateStatus = false
        } catch {
            print(error.localizedDescription)
            self.isFetchingMateStatus = false
        }
    }
}

struct SearchMateView: View {
    @StateObject private var viewModel: SearchMateViewModel = .init()
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.loadedUsers) { user in
                    VStack {
                        Text("User")
                            .font(.headline)
                            .fontWeight(.semibold)
                        HStack {
                            Text(user.email)
                            Text(user.displayName ?? "set Display name")
                        }
                        .onTapGesture {
                            viewModel.isInviteSheetPresented = true
                            viewModel.mateToInvite = user
                        }
                    }
                }
            }
            .sheet(isPresented: $viewModel.isInviteSheetPresented) {
                guard let user = viewModel.mateToInvite else { fatalError("") }
                return VStack {
                    Text("User")
                        .font(.headline)
                        .fontWeight(.semibold)
                    HStack {
                        Text(user.email)
                        Text(user.displayName ?? "set Display name")
                    }
                    Button {
                        // Action
                    } label: {
                        Text(viewModel.mateStatus)
                            .foregroundStyle(.background)
                            .padding(10)
                            .background(
                                Color.green,
                                in: .capsule
                            )
                            .overlay {
                                ProgressView()
                                    .opacity(viewModel.isFetchingMateStatus ? 1 : 0)
                            }
                        }
                    }
                }
                .presentationDetents([.fraction(50)])
            }
            .overlay {
                ZStack {
                    Text("No recent mates")
                        .opacity(viewModel.loadedUsers.isEmpty ? 1 : 0)
                    Group {
                        Color.white.opacity(0.35)
                        ProgressView()
                    }
                    .opacity(viewModel.isFetchingUsers ? 1 : 0)
                }
            }
        }
        .searchable(text: $viewModel.mateName)
        .onChange(of: viewModel.mateName) { _, newValue in
            Task {
                await viewModel.search()
            }
        }
    }
}
