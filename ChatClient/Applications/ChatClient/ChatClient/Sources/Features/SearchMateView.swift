//
//  SearchMateView.swift
//  ChatClient
//
//  Created by setuper on 10.10.2025.
//

import SwiftUI

final class SearchMateViewModel: ObservableObject {
    
    @Published var mateName: String = ""
    @Published var isFetchingUsers = false
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
    
    @MainActor
    func search() async {
        do {
            self.isFetchingUsers = true
            let obtainedUsers = try await NetworkManager.shared.obtainUsersByNamePrefix(email: mateName)
            self.isFetchingUsers = false
            if loadedUsers != obtainedUsers {
                self.loadedUsers = obtainedUsers
            }
        } catch {
            print(error.localizedDescription)
            self.isFetchingUsers = false
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
                        Text("Add mate")
                            .padding(5)
                            .background(
                                Color.green,
                                in: .capsule
                            )
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
