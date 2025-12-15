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
import API
import Services

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
    var body: some Scene {
        WindowGroup {
            //ChatClient()
            NavigationStack {
                ChatView(
                    socketManager: WebSocketManager(
                        cryptoKeysManager: CryptoManager(),
                        userId: User.maybachDanil().id.uuidString,
                        peerId: User.danilMaybach().id.uuidString
                    )
                )
            }
        }
    }
}

struct ChatClient: View {
    private var heed = Heed()
    
    var body: some View {
        RootView()
            .environment(\EnvironmentValues.heed, heed)
    }
}
