//
//  MateStatusPageView.swift
//  ChatClient
//
//  Created by setuper on 15.11.2025.
//

import SwiftUI

struct MateStatusPageView: View {
    @State private var isFetchingMateStatus = false
    var mate: User
    @State private var mateStatus: String = ""
    var mateStatusService: IMateStatusService = MateStatusService()
    
    init(
        mate: User
    ) {
        self.mate = mate
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
        .onAppear {
            Task {
                defer { isFetchingMateStatus = false }
                isFetchingMateStatus = true
                mateStatus = await mateStatusService.status(mate: mate)
            }
        }
    }
}
