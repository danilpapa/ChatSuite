//
//  Chat.swift
//  ChatClient
//
//  Created by setuper on 15.11.2025.
//

import Foundation

struct Chat: Identifiable {
    
    let mateEmail: String
    
    var id: String {
        mateEmail
    }
}
