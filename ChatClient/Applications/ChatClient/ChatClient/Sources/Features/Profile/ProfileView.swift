//
//  ProfileView.swift
//  ChatClient
//
//  Created by setuper on 30.11.2025.
//

import SwiftUI
import API

struct ProfileView: View {
    @EnvironmentObject var router: Router
    @State private var selectedAction: ProfileAction?
    
    var user: User
    
    var body: some View {
        VStack {
            List {
                ForEach(ProfileAction.allCases, id: \.self) { profileAction in
                    Button(ProfileAction.friendList.rawValue) {
                        selectedAction = profileAction
                    }
                }
            }
        }
        .sheet(item: $selectedAction) { action in
            switch action {
            case .friendList:
                ActiveFriendsView(user: user)
            }
        }
    }
}

enum ProfileAction: String, Hashable, CaseIterable, Identifiable {
    
    case friendList = "Friends"
    
    var id: String {
        self.rawValue
    }
}
