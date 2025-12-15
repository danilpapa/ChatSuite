//
//  RecentChatsView.swift
//  ChatClient
//
//  Created by setuper on 16.10.2025.
//

import SwiftUI
import API
import Services

struct RecentChatsView: View {
    @EnvironmentObject var router: Router
    @State private var isMateSelectionPresented = false
    @State private var isSingleChatAlertPresented: Bool = false
    
    private var user: User
    @Binding private var mateToChat: User?
    
    init(user: User, mateToChat: Binding<User?>) {
        self.user = user
        self._mateToChat = mateToChat
    }
    
    var body: some View {
        VStack {
            Text("Start chatting now")
                .foregroundStyle(.gray)
                .font(.callout)
            Button {
                if mateToChat == nil {
                    isMateSelectionPresented = true
                } else {
                    isSingleChatAlertPresented = true
                }
            } label: {
                Image(systemName: "plus.message.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                    .foregroundStyle(.blue)
                    .glassEffect()
            }
        }
        .sheet(isPresented: $isMateSelectionPresented) {
            MateSelectionView(
                user: user,
                isPresented: $isMateSelectionPresented,
                selectedMate: $mateToChat
            )
        }
        .alert(
            "Ooops",
            isPresented: $isSingleChatAlertPresented
        ) {
            Button("Would you like to cancel it?", role: .destructive) {
                // TODO: cancel
            }
            Button("Ok", role: .cancel) { }
        } message: {
            Text("You already have an active chat request")
        }
    }
}

fileprivate struct MateSelectionView: View {
    @State private var activeFriends: [User] = []
    @State private var isFetchingRequest: Bool = false
    private var user: User
    @Binding private var isPresented: Bool
    @Binding private var selectedMate: User?
    
    fileprivate init(
        user: User,
        isPresented: Binding<Bool>,
        selectedMate: Binding<User?>
    ) {
        self.user = user
        self._isPresented = isPresented
        self._selectedMate = selectedMate
    }
    
    var body: some View {
        Group {
            List {
                ForEach(activeFriends) { friend in
                    Text(friend.email)
                        .onTapGesture {
                            selectedMate = friend
                            isPresented = false
                        }
                }
            }
            .overlay {
                ZStack {
                    Color.gray.opacity(0.3)
                    ProgressView()
                }
                .opacity(isFetchingRequest ? 1 : 0)
            }
        }
        .task {
            isFetchingRequest = true
            defer { isFetchingRequest = false }
            do {
                activeFriends = try await UserClient.shared.activeFriends(for: user)
            } catch {
                print(error.localizedDescription)
                print(#file)
            }
        }
    }
}

#if DEBUG
#Preview {
    RootView()
}
#endif
