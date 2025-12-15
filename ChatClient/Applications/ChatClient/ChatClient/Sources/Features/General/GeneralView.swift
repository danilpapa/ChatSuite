//
//  GeneralView.swift
//  ChatClient
//
//  Created by setuper on 30.11.2025.
//

import SwiftUI
import API

struct GeneralView: View {
    @StateObject private var router = Router()
    var user: User
    
    var body: some View {
        NavigationStack(path: $router.path) {
            RecentChatsView(user: user)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            router.push(.friendRequest(user))
                        } label: {
                            Image(systemName: "person.checkmark.and.xmark")
                                .foregroundStyle(.blue)
                        }
                        .buttonStyle(.glass)
                    }
                }
                .navigationDestination(for: AppRoutes.self) {
                    $0.destination
                        .environmentObject(router)
                }
                .navigationTitle("FireChat")
        }
    }
}
