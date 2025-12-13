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
                .font(.headline)
                .fontWeight(.semibold)
            HStack {
                Text(mate.email)
            }
            Button {
                mateStatus = nil
            } label: {
                Text(mateStatus?.title ?? "No title")
                    .foregroundStyle(.background)
                    .padding(10)
                    .background(
                        Color.green,
                        in: .capsule
                    )
            }
        }
    }
}
