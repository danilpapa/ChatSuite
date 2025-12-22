//
//  RootView.swift
//  ChatClient
//
//  Created by setuper on 15.11.2025.
//

import SwiftUI
import HeedAssembly
import API
import SwiftData

struct RootView: View {
    @Environment(\.heed) var heed
    @State private var loginManager: ILoginManager = LoginManager(isLoggedIn: false)
    
    @Query private var users: [UserData]
    
    private var currentUser: User? {
        guard let userData = users.first else { return nil }
        return User(userData: userData)
    }
    
    var body: some View {
        Group {
            if let currentUser {
                MainView()
                    .environment(\EnvironmentValues.heed, heed)
                    .environmentObject(AppState(user: currentUser))
            } else {
                LoginView(
                    loginManager: loginManager
                )
                .environment(\EnvironmentValues.heed, heed)
            }
        }
    }
}

#if DEBUG
#Preview {
    RootView()
}
#endif
