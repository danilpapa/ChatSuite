//
//  Routes.swift
//  ChatClient
//
//  Created by setuper on 12.10.2025.
//

import Foundation
import SwiftUI

enum AuthenticationFlow: Hashable {
    
    case login
}

extension AuthenticationFlow {
    @ViewBuilder
    var body: some View {
        switch self {
        case .login:
            LoginView()
        }
    }
}

