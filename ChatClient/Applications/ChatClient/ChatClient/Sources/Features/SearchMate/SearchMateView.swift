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
    
    var mateClient: IMateClient
    var displayedUsers: [User]
    
    var body: some View {
        VStack {
            List {
                ForEach(displayedUsers) { user in
                    Text(user.email)
                        .onTapGesture {
                            isMateDetailShown = true
                        }
                        .sheet(isPresented: $isMateDetailShown) {
                            MateStatusPageView(mate: user, mateClient: mateClient)
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
