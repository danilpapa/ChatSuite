//
//  SearchMateView.swift
//  ChatClient
//
//  Created by setuper on 10.10.2025.
//

import SwiftUI

struct SearchMateView: View {
    @EnvironmentObject var router: Router
    
    var displayedUsers: [User]
    
    var body: some View {
        VStack {
            List {
                ForEach(displayedUsers) { user in
                    NavigationLink(value: AppRoute.main(.mateStatusPage(user))) {
                        Text(user.email)
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
