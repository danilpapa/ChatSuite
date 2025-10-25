//
//  SearchMateView.swift
//  ChatClient
//
//  Created by setuper on 10.10.2025.
//

import SwiftUI

final class SearchMateViewModel: ObservableObject {
    typealias User = String
    
    @Published var mateName: String = ""
    @Published var isFetchingUsers = false
    @Published var loadedUsers: [String] = []
    
    init() { }
    
    @MainActor
    func search() async {
        do {
            self.isFetchingUsers = true
            let obtainedUsers = try await NetworkManager.shared.obtainUsers(email: mateName)
            self.isFetchingUsers = false
            self.loadedUsers = obtainedUsers.map {
                $0.email
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
            if viewModel.isFetchingUsers {
                ProgressView()
            } else {
                ZStack {
                    Color.gray
                        .opacity(0.35)
                        .ignoresSafeArea()
                    Text("No recent mates")
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
