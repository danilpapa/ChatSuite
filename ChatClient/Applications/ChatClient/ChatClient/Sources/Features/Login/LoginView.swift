//
//  EmailLogin.swift
//  ChatClient
//
//  Created by setuper on 25.09.2025.
//

import SwiftUI
import FirebaseCrashlytics
import FirebaseCrashlyticsSwift
import GoogleSignIn
import Firebase
import API

struct LoginView: View {
    @EnvironmentObject var loginState: LoginState
    @Environment(\.heed) var heed
    @State private var isFetchingRequest = false
    @State private var showLoginErrorAlert = false
    private var googleSignInService: IGoogleSignInService
    private var loginClient: ILogiClient { heed.loginClient }
    
    init(googleSignInService: IGoogleSignInService = GoogleSignInService()) {
        self.googleSignInService = googleSignInService
    }
    
    var body: some View {
        VStack {
            Button("Sign in with google") {
                Task {
                    isFetchingRequest = true
                    let googleCredentials = await googleSignInService.signIn(loginClient: loginClient)
                    if let googleCredentials {
                        let user = User(id: googleCredentials.id, email: googleCredentials.email)
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
