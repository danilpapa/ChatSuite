//
//  RootView.swift
//  ChatClient
//
//  Created by setuper on 15.11.2025.
//

import SwiftUI
import HeedAssembly

struct RootView: View {
    @EnvironmentObject var loginState: LoginState
    @Environment(\.heed) var heed
    private var userService: IUserService
    
    init(
        userService: IUserService
    ) {
        self.userService = userService
    }
    
    var body: some View {
        Group {
            if loginState.isLoggedIn {
                MainView(user: loginState.getUser(), userService: userService, mateClient: heed.mateClient)
                    .environment(\EnvironmentValues.heed, heed)
            } else {
                LoginView()
                    .environment(\EnvironmentValues.heed, heed)
            }
        }
    }
}
