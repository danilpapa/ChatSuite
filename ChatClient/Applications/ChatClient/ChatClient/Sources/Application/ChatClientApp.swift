//
//  ChatClientApp.swift
//  ChatClient
//
//  Created by setuper on 06.09.2025.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import HeedAssembly
import NeedleFoundation

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        registerProviderFactories()
        return true
    }
}

@main
struct ChatClientApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var router = Router()
    var body: some Scene {
        WindowGroup {
            ChatClient(router: router)
        }
    }
}

struct ChatClient: View {
    private var heed = Heed()
    private var router: Router
    @StateObject private var loginState = LoginState()
    private var userService: IUserService = UserService()
    
    init(router: Router) {
        self.router = router
    }
    
    var body: some View {
        RootView(
            userService: userService
        )
        .environmentObject(router)
        .environmentObject(loginState)
        .environment(\EnvironmentValues.heed, heed)
    }
}

#Preview {
    ChatClient(router: Router())
}
