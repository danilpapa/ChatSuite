//
//  GoogleSignInManager.swift
//  ChatClient
//
//  Created by setuper on 12.10.2025.
//

import Firebase
import FirebaseAuth
import GoogleSignIn

enum GoogleSignInErrors: Error {
    
    case missingClientId
    case noIdToken
    case noEmail
    case signInFailed(String)
}

enum GoogleSignInManager {
    
    static func signInWithGoogle(presentingViewController: UIViewController) async throws -> GoogleCredentials_ {
        guard let clientId = FirebaseApp.app()?.options.clientID else {
            throw GoogleSignInErrors.missingClientId
        }
        
        let clientConfig = GIDConfiguration(clientID: clientId)
        GIDSignIn.sharedInstance.configuration = clientConfig
        
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController)
            let user = result.user
            guard let idToken = user.idToken else {
                throw GoogleSignInErrors.noIdToken
            }
            guard let email = user.profile?.email else {
                throw GoogleSignInErrors.noEmail
            }
            return .init(email: email, firebaseToken: idToken.tokenString)
        } catch {
            throw GoogleSignInErrors.signInFailed(error.localizedDescription)
        }
    }
}
