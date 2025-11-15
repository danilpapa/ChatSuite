//
//  GoogleSingInService.swift
//  ChatClient
//
//  Created by setuper on 15.11.2025.
//

import Foundation

//final class LoginViewModel: ObservableObject {
//    var router: Router?
//    var loginState: LoginState?
//    @Published var isFetchingRequest: Bool = false
//
//    @MainActor
//    func signInViaGoogle() async {
//        guard let presentingViewController = topViewController() else {
//            return
//        }
//        do {
//            let userCredentials = try await GoogleSignInManager.signInWithGoogle(
//                presentingViewController: presentingViewController
//            )
//            let loggedUserId = try await NetworkManager.shared.login(with: userCredentials)
//            loginState?.isLoggedIn = true
//            loginState?.loggedUser = User(
//                id: loggedUserId,
//                email: userCredentials.email
//            )
//        } catch {
//            // log
//        }
//    }
//}

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
            let loggedUserId = try await NetworkManager.shared.login(with: userCredentials)
            return User(id: loggedUserId, email: userCredentials.email)
        } catch {
            print(#file)
            print(error.localizedDescription)
            return nil
        }
    }
}
