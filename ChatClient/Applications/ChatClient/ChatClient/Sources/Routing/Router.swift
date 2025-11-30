//
//  Router.swift
//  ChatClient
//
//  Created by setuper on 15.11.2025.
//

import SwiftUI

final class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ screen: AppRoutes) {
        path.append(screen)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func reset() {
        path = NavigationPath()
    }
}
