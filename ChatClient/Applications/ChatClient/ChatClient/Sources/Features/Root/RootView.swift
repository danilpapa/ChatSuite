//
//  RootView.swift
//  ChatClient
//
//  Created by setuper on 15.11.2025.
//

import SwiftUI
import HeedAssembly
import API

struct RootView: View {
    @Environment(\.heed) var heed
    @State private var loginManager: ILoginManager = LoginManager(isLoggedIn: true, loggedUser: .maybachDanil())
    
    var body: some View {
        Group {
            if loginManager.isLoggedIn {
                MainView()
                    .environment(\EnvironmentValues.heed, heed)
                    .environmentObject(AppState(user: loginManager.getUser()))
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
