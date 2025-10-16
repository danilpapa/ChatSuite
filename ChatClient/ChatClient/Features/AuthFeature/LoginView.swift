//
//  EmailLogin.swift
//  ChatClient
//
//  Created by setuper on 25.09.2025.
//

import SwiftUI
import FirebaseCrashlytics
import FirebaseCrashlyticsSwift

// TODO: Handle
final class LoginViewModel: ObservableObject {
    @Binding var path: NavigationPath
    
    @Published var isFetchingRequest: Bool = false
    
    init(path: Binding<NavigationPath>) {
        self._path = path
    }
    
    @MainActor
    func signInViaGoogle() async {
        guard let presentingViewController = topViewController() else {
            return
        }
        do {
            let userCredentials = try await GoogleSignInManager.signInWithGoogle(
                presentingViewController: presentingViewController
            )
            let loggedUserId = try await NetworkManager.shared.logIn(with: userCredentials)
            path.append(Routes.mainFeature(User(id: loggedUserId, email: userCredentials.email)))
        } catch {
            // log
        }
    }
}

struct LoginView: View {
    @StateObject private var vm: LoginViewModel
    
    init(path: Binding<NavigationPath>) {
        self._vm = StateObject(wrappedValue: LoginViewModel(path: path))
    }
    
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
    }
}
