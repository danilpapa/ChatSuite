//
//  RouterResolver.swift
//  ChatClient
//
//  Created by setuper on 15.11.2025.
//

import SwiftUI

enum RouterResolver {
    
    @ViewBuilder
    static func resolve(_ route: AppRoute) -> some View {
        switch route {
        case .auth(let authenticationFlow):
            switch authenticationFlow {
            case .login:
                LoginView()
            }
        case .main(let mainFlow):
            switch mainFlow {
            case .mainPage:
                SearchMateView()
            }
        }
    }
}
