//
//  SignInView.swift
//  ChatClient
//
//  Created by setuper on 22.09.2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift

struct User: Identifiable {
    
    let publicName: String
    let userId: String
    
    var id: String {
        userId
    }
}

struct SignInView: View {
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            Button {
                Task {
                    do {
                        guard let loggedUser = try await SignInHelper.shared.googleSignIn() else { return }
                        print(loggedUser)
                    } catch {
                        print("Google login error: \(error.localizedDescription)")
                    }
                }
            } label: {
                Image(.google)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 44)
                    .padding()
                    .glassEffect()
            }
            .padding()
        }
    }
}

struct SignInHelper {
    
    static let shared: SignInHelper = .init()
    
    private init() { }
    
    @MainActor
    func googleSignIn() async throws -> User? {
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError.init(.cannotFindHost)
        }
        
        guard let clientId = FirebaseApp.app()?.options.clientID else { return nil }
    
        let config = GIDConfiguration(clientID: clientId)
        GIDSignIn.sharedInstance.configuration = config
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
            
            guard let idToken = result.user.idToken?.tokenString else { return nil }
            let accessToken = result.user.accessToken.tokenString
            
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            let authResult = try await Auth.auth().signIn(with: credentials)
            let user = authResult.user
            return User(
                publicName: user.displayName ?? "no_name",
                userId: user.uid
            )
        } catch {
            print("Sign in error: \(error)")
            throw error
        }
    }
}

#Preview {
    SignInView()
}
