//
//  SearchMateView.swift
//  ChatClient
//
//  Created by setuper on 10.10.2025.
//

import SwiftUI

struct SearchMateView: View {
    @EnvironmentObject var router: Router
    @State private var loadedUsers: [User] = []
    @State private var isFetchingUsers = false
    @State private var mateRequest: String = "" {
        didSet {
            Task {
                isFetchingUsers = true
                loadedUsers = await userService.searchViaPreffix(mateRequest)
                isFetchingUsers = false
            }
        }
    }
    
    private var userService: IUserService
    
    init(userService: IUserService) {
        self.userService = userService
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(loadedUsers) { user in
                    VStack {
                        Text(user.email)
                        .onTapGesture {
                            router.push(.main(.mateStatusPage(user)))
                        }
                    }
                }
            }
        }
        .overlay {
            ZStack {
                Text("No recent mates")
                    .opacity(loadedUsers.isEmpty ? 1 : 0)
                Group {
                    Color.white.opacity(0.35)
                    ProgressView()
                }
                .opacity(isFetchingUsers ? 1 : 0)
            }
        }
        .searchable(text: $mateRequest)
    }
}
