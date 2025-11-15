//
//  AppRouter.swift
//  ChatClient
//
//  Created by setuper on 15.11.2025.
//

import Foundation

enum AppRoute: Hashable {
    
    case auth(AuthenticationFlow)
    case main(MainFlow)
}
