//
//  GeneralView.swift
//  ChatClient
//
//  Created by setuper on 30.11.2025.
//

import SwiftUI
import API

struct GeneralView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var router = Router()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            RecentChatsView()
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            router.push(.friendRequest(appState.user))
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
                .environmentObject(router)
        }
    }
}

#Preview {
    ChatClient()
}
