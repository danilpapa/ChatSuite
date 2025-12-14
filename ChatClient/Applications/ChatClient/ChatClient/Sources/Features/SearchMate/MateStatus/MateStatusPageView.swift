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
    private var user: User
    private var mate: User
    private var mateStatus: MateStatus
    private let onClose: () -> Void
    
    public init(
        user: User,
        mate: User,
        mateStatus: MateStatus,
        onClose: @escaping () -> Void
    ) {
        self.user = user
        self.mate = mate
        self.mateStatus = mateStatus
        self.onClose = onClose
    }
    
    
    var body: some View {
        VStack {
            Text("Mate")
                .foregroundStyle(.background)
                .font(.headline)
                .padding()
                .glassEffect(.regular.tint(.blue))
            HStack {
                Text(mate.email)
            }
            actionButton
        }
    }
    
    @ViewBuilder
    private var actionButton: some View {
        if case .expectation = mateStatus {
            HStack (spacing: .zero) {
                Button(MateStatus.accept.title) {
                    buttonAction(status: .accept)
                }
                .buttonStyle(.glassProminent)
                .tint(MateStatus.accept.tint)
                
                Button(MateStatus.discard.title) {
                    buttonAction(status: .discard)
                }
                .buttonStyle(.glassProminent)
                .tint(MateStatus.discard.tint)
            }
        } else {
            Button(mateStatus.title){
                buttonAction(status: mateStatus)
            }
            .buttonStyle(.glassProminent)
            .tint(mateStatus.tint)
        }
    }
    
    private func buttonAction(status: MateStatus) {
        Task.detached {
            do {
                try await UserClient.shared.mateStatusAction(
                    status: status,
                    from: user.id,
                    to: mate.id
                )
            } catch {
                // handle
                print(error)
            }
        }
        onClose()
    }
}
