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
    @Binding private var mateStatus: MateStatus?
    
    init(
        user: User,
        mate: User,
        mateStatus: Binding<MateStatus?>
    ) {
        self.user = user
        self.mate = mate
        self._mateStatus = mateStatus
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
//                guard
//                    let mateStatus,
//                    mateStatus != .pending
//                else { return }
//                Task.detached {
//                    do {
//                        try await UserClient.shared.mateStatusAction(
//                            status: mateStatus,
//                            from: user.id,
//                            to: mate.id
//                        )
//                    } catch {
//                        // handle
//                        print(error)
//                    }
//                }
//                self.mateStatus = nil
        }
    }
    
    @ViewBuilder
    private var actionButton: some View {
        if let mateStatus {
            if case .acceptDiscard = mateStatus {
                HStack (spacing: .zero) {
                    Button("Accept") {
                        
                    }
                    .buttonStyle(.glassProminent)
                    
                    Button("Discard") {
                        
                    }
                    .buttonStyle(.glassProminent)
                    .tint(.red)
                }
            } else {
                Button(mateStatus.title){
                    Task.detached {
                        do {
                            try await UserClient.shared.mateStatusAction(
                                status: mateStatus,
                                from: user.id,
                                to: mate.id
                            )
                        } catch {
                            // handle
                            print(error)
                        }
                    }
                }
                .buttonStyle(.glassProminent)
                .tint(mateStatus.tint)
            }
        }
    }
}
