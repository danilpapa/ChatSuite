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
                            AvatarHeaderView(width: proxy.size.width / 2)
                                .padding(.vertical)
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.white)
                        
                        Section {
                            ButtonView(action: .changePhoto)
                        }
                        
                        Section("See all your friends!") {
                            ButtonView(action: .friendList)
                        }
                        
                        Section("Personal metrics") {
                            ButtonView(action: .stats)
                            ButtonView(action: .analytics)
                        }
                        
                        Section("Have questions?") {
                            ButtonView(action: .support)
                        }
                    }
                }
            }
            .sheet(item: $selectedAction) { action in
                switch action {
                case .friendList:
                    ActiveFriendsView(user: user)
                case .stats, .analytics, .changePhoto, .support:
                    Color.clear
                }
            }
            .navigationDestination(for: AppRoutes.self) { $0.destination }
        }
    }
    
    private func ButtonView(action: ProfileAction) -> some View {
        Button {
            selectedAction = action
        } label: {
            HStack(alignment: .center) {
                action.icon
                Text(action.rawValue)
                    .foregroundStyle(.black)
            }
        }
    }
    
    @ViewBuilder
    private func AvatarHeaderView(width: CGFloat) -> some View {
        VStack(spacing: .zero) {
            HStack {
                Spacer()
                UserAvatarImage(width: width)
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
    
    @ViewBuilder
    private func UserAvatarImage(width: CGFloat) -> some View {
        Image(systemName: "person.crop.circle.fill.badge.plus")
            .resizable()
            .scaledToFit()
            .frame(width: width)
            .foregroundStyle(.ultraThinMaterial)
            .rotationEffect(.degrees(18))
            .overlay(alignment: .bottom) {
                Rectangle()
                    .foregroundStyle(.background)
                    .frame(height: width / 5)
                    .overlay {
                        Text("Tap to add image")
                            .foregroundStyle(.gray.opacity(0.75))
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
            }
    }
}

enum ProfileAction: String, Hashable, Identifiable {
    
    case changePhoto = "Change profile photo"
    case friendList = "Friends"
    case stats = "Statistics"
    case analytics = "Analytics"
    case support = "Chat us"
    
    @ViewBuilder
    var icon: some View {
        Image(systemName: self.systemIconName)
            .resizable()
            .scaledToFit()
            .frame(width: 20)
            .foregroundStyle(self.iconColor)
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
        case .analytics:
            return "distribute.horizontal.center.fill"
        case .support:
            return "questionmark.message.fill"
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
        case .analytics:
            return .cyan
        case .support:
            return .orange
        }
    }
}

#if DEBUG
#Preview {
    ChatClient()
}
#endif
