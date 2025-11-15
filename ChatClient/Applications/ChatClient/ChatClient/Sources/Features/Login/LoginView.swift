//
//  EmailLogin.swift
//  ChatClient
//
//  Created by setuper on 25.09.2025.
//

import SwiftUI
import FirebaseCrashlytics
import FirebaseCrashlyticsSwift

struct LoginView: View {
    @EnvironmentObject var loginState: LoginState
    @State private var isFetchingRequest = false
    @State private var showLoginErrorAlert = false
    
    private var googleSignInService: IGoogleSignInService
    
    init(googleSignInService: IGoogleSignInService) {
        self.googleSignInService = googleSignInService
    }
    
    var body: some View {
        VStack {
            Button("Sign in with google") {
                Task {
                    isFetchingRequest = true
                    let user = await googleSignInService.signIn()
                    if let user {
                        loginState.loggedUser = user
                        loginState.isLoggedIn = true
                    } else {
                        showLoginErrorAlert = true
                    }
                    isFetchingRequest = false
                }
            }
            .disabled(isFetchingRequest)
        }
        .alert(
            "Error via login with google",
            isPresented: $showLoginErrorAlert
        ) {
            Button("Ok", role: .cancel) { }
        }
    }
}
