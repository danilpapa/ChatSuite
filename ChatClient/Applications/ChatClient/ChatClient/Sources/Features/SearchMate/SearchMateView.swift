//
//  SearchMateView.swift
//  ChatClient
//
//  Created by setuper on 10.10.2025.
//

import SwiftUI
import API

struct SearchMateView: View {
    @EnvironmentObject var router: Router
    @State private var isMateDetailShown = false
    
    private var user: User
    private var displayedUsers: [User]
    
    init(user: User, displayedUsers: [User]) {
        self.user = user
        self.displayedUsers = displayedUsers
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(displayedUsers) { mate in
                    Text(mate.email)
                        .onTapGesture {
                            isMateDetailShown = true
                        }
                        .sheet(isPresented: $isMateDetailShown) {
                            MateStatusPageView(user: user, mate: mate)
                        }
                }
            }
            .overlay {
                Text("No recent mates")
                    .opacity(displayedUsers.isEmpty ? 1 : 0)
            }
        }
    }
}

#Preview {
    ChatClient(router: Router())
}
