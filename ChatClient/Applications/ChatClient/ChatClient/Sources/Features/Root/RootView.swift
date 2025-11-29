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
    private var userService: IUserService
    
    init(
        userService: IUserService,
    ) {
        self.userService = userService
    }
    
    var body: some View {
        Group {
            if loginManager.isLoggedIn {
                MainView(
                    user: loginManager.getUser(),
                    userService: userService
                )
                .environment(\EnvironmentValues.heed, heed)
            } else {
                LoginView(
                    loginManager: loginManager
                )
                .environment(\EnvironmentValues.heed, heed)
            }
        }
    }
}
