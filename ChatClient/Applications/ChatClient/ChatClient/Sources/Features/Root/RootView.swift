//
//  RootView.swift
//  ChatClient
//
//  Created by setuper on 15.11.2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var loginState: LoginState
    
    var body: some View {
        Group {
            if loginState.isLoggedIn {
                SearchMateView()
                    .onAppear {
                        print(loginState.loggedUser)
                    }
            } else {
                LoginView()
            }
        }
    }
}
