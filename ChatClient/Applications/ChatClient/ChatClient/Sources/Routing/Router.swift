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
        print(path)
        path.append(route)
        print(path)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func clear() {
        path = NavigationPath()
    }
}
