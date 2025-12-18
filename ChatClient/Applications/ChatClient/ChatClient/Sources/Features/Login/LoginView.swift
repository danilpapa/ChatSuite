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
            MainImage
            Spacer()
            MainPannel
        }
        .padding(.vertical, 35)
        .alert(
            "Error via login with google",
            isPresented: $showLoginErrorAlert
        ) {
            Button("Ok", role: .cancel) { }
        }
    }
    
    @ViewBuilder
    private var MainImage: some View {
        ChatClientAsset.Assets.authImage.swiftUIImage
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
    }
    
    @ViewBuilder
    private var MainPannel: some View {
        Button { }
        label: {
            Text("Sign in with apple")
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .padding()
                .glassEffect(.regular.tint(.blue.opacity(0.6)))
                .padding(.horizontal)
        }
        .disabled(isFetchingRequest)
        
        Button {
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
        } label: {
            Text("Sign in with google")
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .padding()
                .glassEffect(.clear.tint(.black))
                .padding(.horizontal)
        }
        .disabled(isFetchingRequest)
    }
}

#Preview {
    LoginView(loginManager: LoginManager(isLoggedIn: false))
}
