//
//  EmailLogin.swift
//  ChatClient
//
//  Created by setuper on 25.09.2025.
//

import SwiftUI
import FirebaseCrashlytics
import FirebaseCrashlyticsSwift

final class LoginViewModel: ObservableObject {
    var router: Router?
    var loginState: LoginState?
    @Published var isFetchingRequest: Bool = false
    
    @MainActor
    func signInViaGoogle() async {
        guard let presentingViewController = topViewController() else {
            return
        }
        do {
            let userCredentials = try await GoogleSignInManager.signInWithGoogle(
                presentingViewController: presentingViewController
            )
            let loggedUserId = try await NetworkManager.shared.login(with: userCredentials)
            loginState?.isLoggedIn = true
            loginState?.loggedUser = User(
                id: loggedUserId,
                email: userCredentials.email
            )
        } catch {
            // log
        }
    }
}

struct LoginView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var loginState: LoginState
    @StateObject private var vm = LoginViewModel()
    
    var body: some View {
        ZStack {
            Button("Sign in with google") {
                Task {
                    await vm.signInViaGoogle()
                }
            }
            .disabled(vm.isFetchingRequest)
            
            ProgressView()
                .opacity(vm.isFetchingRequest ? 1 : 0)
        }
        .onAppear {
            vm.router = router
            vm.loginState = loginState
        }
    }
}
