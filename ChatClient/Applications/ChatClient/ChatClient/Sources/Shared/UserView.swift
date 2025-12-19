//
//  UserView.swift
//  ChatClient
//
//  Created by setuper on 19.12.2025.
//

import SwiftUI
import API

struct UserView: View {
    
    var user: User
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.blue.opacity(0.2))
                .scaledToFit()
                .frame(width: 44)
                .overlay(
                    Text(user.email.prefix(1).uppercased())
                        .font(.headline)
                        .foregroundColor(.blue)
                )
            VStack(alignment: .leading, spacing: 4) {
                Text(user.email)
                    .font(.headline)
                    .lineLimit(1)
                // TODO: request
                Text("В сети")
                    .font(.caption)
                    .foregroundColor(.green)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
    }
}
