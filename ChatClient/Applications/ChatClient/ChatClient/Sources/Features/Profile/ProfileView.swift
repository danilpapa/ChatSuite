//
//  ProfileView.swift
//  ChatClient
//
//  Created by setuper on 30.11.2025.
//

import SwiftUI
import API

struct ProfileView: View {
    @StateObject private var router = Router()
    @State private var selectedAction: ProfileAction?
    
    var user: User
    
    var body: some View {
        NavigationStack(path: $router.path) {
            GeometryReader { proxy in
                VStack(spacing: .zero) {
                    List {
                        Section {
                            AvatarHeaderView(width: proxy.size.width / 3)
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        
                        ForEach(ProfileAction.allCases, id: \.self) { profileAction in
                            ProfileActionView(for: profileAction)
                        }
                    }
                }
            }
            .sheet(item: $selectedAction) { action in
                switch action {
                case .changePhoto:
                    Color.blue
                case .friendList:
                    ActiveFriendsView(user: user)
                case .stats:
                    Color.clear
                }
            }
            .navigationDestination(for: AppRoutes.self) { $0.destination }
        }
    }
    
    @ViewBuilder
    private func ProfileActionView(for action: ProfileAction) -> some View {
        if let description = action.description {
            Section(description) {
                ButtonView(action: action)
            }
        } else {
            ButtonView(action: action)
        }
        
    }
    
    private func ButtonView(action: ProfileAction) -> some View {
        Button {
            selectedAction = action
        } label: {
            HStack(alignment: .center) {
                action.icon
                Text(action.rawValue)
            }
        }
    }
    
    @ViewBuilder
    private func AvatarHeaderView(width: CGFloat) -> some View {
        VStack(spacing: .zero) {
            HStack {
                Spacer()
                UserAvatarImage
                    .resizable()
                    .clipShape(.circle)
                    .scaledToFit()
                    .frame(width: width)
                Spacer()
            }
            .padding(.bottom, 16)
            Text(user.email.split(separator: "@").first ?? "")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 8)
            Text(user.email)
                .foregroundStyle(.gray)
                .font(.callout)
        }
    }
    
    private var UserAvatarImage: Image {
        ChatClientAsset.Assets.plainUserImage.swiftUIImage
    }
}

enum ProfileAction: String, Hashable, CaseIterable, Identifiable {
    
    case changePhoto = "Change profile photo"
    case friendList = "Friends"
    case stats = "Statistics"
    
    @ViewBuilder
    var icon: some View {
        Image(systemName: self.systemIconName)
            .resizable()
            .scaledToFit()
            .frame(width: 20)
            .foregroundStyle(self.iconColor)
    }
    
    var description: String? {
        switch self {
        case .changePhoto:
            nil
        case .friendList:
            "See all your active friends!"
        case .stats:
            nil
        }
    }
    
    var id: String {
        self.rawValue
    }
    
    private var systemIconName: String {
        switch self {
        case .changePhoto:
            return "photo.on.rectangle"
        case .friendList:
            return "person.2.fill"
        case .stats:
            return "graph.2d"
        }
    }
    
    private var iconColor: Color {
        switch self {
        case .changePhoto:
            return .blue
        case .friendList:
            return .pink
        case .stats:
            return .green
        }
    }
}

#if DEBUG
#Preview {
    ProfileView(user: .danilMaybach())
}
#endif
