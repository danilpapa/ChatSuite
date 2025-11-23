//
//  GoogleSingInService.swift
//  ChatClient
//
//  Created by setuper on 15.11.2025.
//

import Foundation
import Network
import Services

protocol IGoogleSignInService {
    
    @MainActor
    func signIn() async -> User?
}

struct GoogleSignInService: IGoogleSignInService {
    
    func signIn() async -> User? {
        guard let presentingViewController = topViewController() else { return nil }
        do {
            let userCredentials = try await GoogleSignInManager.signInWithGoogle(
                presentingViewController: presentingViewController
            )
            let response = try await LoginService.login(
                email: userCredentials.email,
                fbToken: userCredentials.firebaseToken
            )
            return User(id: response.body.id, email: userCredentials.email)
        } catch {
            print(#file)
            print(error.localizedDescription)
            return nil
        }
    }
}
