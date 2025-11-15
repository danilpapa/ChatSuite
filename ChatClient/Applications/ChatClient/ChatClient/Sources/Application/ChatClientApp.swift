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
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                ChatClient(router: router)
            }
        }
    }
}

struct ChatClient: View {
    private var router: Router
    @StateObject private var loginState = LoginState()
    private var googleSignInService: IGoogleSignInService = GoogleSignInService()
    private var userService: IUserService = UserService()
    private var mateStatusService: IMateStatusService = MateStatusService()
    
    init(router: Router) {
        self.router = router
    }
    
    var body: some View {
        RootView(
            googleSignInService: googleSignInService,
            userService: userService
        )
        .navigationDestination(for: AppRoute.self) { route in
            switch route {
            case .auth(let authenticationFlow):
                switch authenticationFlow {
                case .login:
                    LoginView(googleSignInService: googleSignInService)
                }
            case .main(let mainFlow):
                switch mainFlow {
                case .mainPage:
                    fatalError("Idk resolve via tab")
                case let .mateStatusPage(mate):
                    MateStatusPageView(mate: mate, mateStatusService: mateStatusService)
                }
            }
        }
        .environmentObject(router)
        .environmentObject(loginState)
    }
}

#Preview {
    ChatClient(router: Router())
}
