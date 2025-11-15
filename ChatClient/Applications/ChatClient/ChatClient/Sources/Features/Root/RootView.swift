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
    
    init(googleSignInService: IGoogleSignInService) {
        self.googleSignInService = googleSignInService
    }
    
    var body: some View {
        Group {
            if loginState.isLoggedIn {
                SearchMateView()
            } else {
                LoginView(googleSignInService: googleSignInService)
            }
        }
    }
}
