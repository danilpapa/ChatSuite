//
//  MateStatusPageView.swift
//  ChatClient
//
//  Created by setuper on 15.11.2025.
//

import SwiftUI
import API

struct MateStatusPageView: View {
    @State private var isFetchingMateStatus = false
    var mate: User
    @State private var mateStatus: String = ""
    var mateClient: IMateClient
    
    init(
        mate: User,
        mateClient: IMateClient
    ) {
        self.mate = mate
        self.mateClient = mateClient
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
                do {
                    mateStatus = try await mateClient.getStatus(for: mate.id)
                } catch {
                    print(#file)
                    print(error.localizedDescription)
                }
            }
        }
    }
}
