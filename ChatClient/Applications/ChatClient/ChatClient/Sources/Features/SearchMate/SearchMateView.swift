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
                    VStack {
                        Text(user.email)
                        .onTapGesture {
                            router.push(.main(.mateStatusPage(user)))
                        }
                    }
                }
            }
        }
    }
}
