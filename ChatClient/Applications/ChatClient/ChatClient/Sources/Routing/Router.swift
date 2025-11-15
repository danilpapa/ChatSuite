//
//  Router.swift
//  ChatClient
//
//  Created by setuper on 15.11.2025.
//

import SwiftUI

final class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func clear() {
        path = NavigationPath()
    }
}
