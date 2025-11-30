//
//  View+.swift
//  ChatClient
//
//  Created by setuper on 30.11.2025.
//

import SwiftUI

public extension View {
    
    func tabbarHidder() -> some View {
        self.toolbarVisibility(.hidden, for: .tabBar)
    }
}
