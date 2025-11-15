//
//  ChatClientApp.swift
//  ChatClient
//
//  Created by setuper on 06.09.2025.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct ChatClientApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var router = Router()
    @StateObject private var loginState = LoginState()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                RootView()
                    .navigationDestination(for: AppRoute.self) { route in
                        RouterResolver.resolve(route)
                    }
            }
            .id(loginState.isLoggedIn)
            .environmentObject(router)
            .environmentObject(loginState)
        }
    }
}
