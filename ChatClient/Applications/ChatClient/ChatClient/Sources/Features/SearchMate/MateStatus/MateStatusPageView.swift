//
//  MateStatusPageView.swift
//  ChatClient
//
//  Created by setuper on 15.11.2025.
//

import SwiftUI
import Services
import API

struct MateStatusPageView: View {
    @State private var isFetchingMateStatus = false
    @State private var mateStatus: String = ""
    
    private var user: User
    private var mate: User
    @Binding var isShown: Bool
    
    init(
        user: User,
        mate: User,
        isShown: Binding<Bool>
    ) {
        self.user = user
        self.mate = mate
        self._isShown = isShown
    }
    
    var body: some View {
        VStack {
            Text("Mate")
                .font(.headline)
                .fontWeight(.semibold)
            HStack {
                Text(mate.email)
            }
            Button {
                isShown = false
            } label: {
                Text(mateStatus)
                    .foregroundStyle(.background)
                    .padding(10)
                    .background(
                        Color.green,
                        in: .capsule
                    )
                    .overlay {
                        ProgressView()
                            .opacity(isFetchingMateStatus ? 1 : 0)
                    }
            }
        }
        .task {
            defer { isFetchingMateStatus = false }
            isFetchingMateStatus = true
            do {
                mateStatus = try await MateClient.shared.getStatus(from: user.id, to: mate.id).rawValue
            } catch {
                print(#file)
                print(error.localizedDescription)
            }
        }
    }
}
