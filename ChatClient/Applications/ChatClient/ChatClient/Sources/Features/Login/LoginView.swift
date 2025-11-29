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
    @State private var isFetchingRequest = false
    @State private var showLoginErrorAlert = false
    
    private var googleSignInService: IGoogleSignInService
    @State private var loginManager: ILoginManager
    
    init(
        googleSignInService: IGoogleSignInService = GoogleSignInService(),
        loginManager: ILoginManager
    ) {
        self.googleSignInService = googleSignInService
        self.loginManager = loginManager
    }
    
    var body: some View {
        VStack {
            Button("Sign in with google") {
                Task {
                    isFetchingRequest = true
                    let googleCredentials = await googleSignInService.signIn()
                    if let googleCredentials {
                        let user = User(id: googleCredentials.id, email: googleCredentials.email)
                        loginManager.loggedUser = user
                        loginManager.isLoggedIn = true
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
