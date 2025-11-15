//
//  Routes.swift
//  ChatClient
//
//  Created by setuper on 12.10.2025.
//

import Foundation

enum AuthenticationFlow: Hashable {
    
    case login
}

enum MainFlow: Hashable {
    
    case mateStatusPage(User)
    case friendRequests(User)
}
