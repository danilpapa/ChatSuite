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

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        setupNeedle()
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
    
    init(router: Router) {
        self.router = router
    }
    
    var body: some View {
        RootView()
            .environmentObject(router)
            .environment(\EnvironmentValues.heed, heed)
    }
}

#Preview {
    ChatClient(router: Router())
}
