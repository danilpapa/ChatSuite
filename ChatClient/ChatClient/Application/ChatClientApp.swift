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
    
    var body: some Scene {
        WindowGroup {
            SignInView()
        }
    }
}
