//
//  RootView.swift
//  ChatClient
//
//  Created by setuper on 15.11.2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var loginState: LoginState
    private var googleSignInService: IGoogleSignInService
    private var userService: IUserService
    
    init(
        googleSignInService: IGoogleSignInService,
        userService: IUserService
    ) {
        self.googleSignInService = googleSignInService
        self.userService = userService
    }
    
    var body: some View {
        Group {
            if loginState.isLoggedIn {
                SearchMateView(userService: userService)
            } else {
                LoginView(googleSignInService: googleSignInService)
            }
        }
    }
}
