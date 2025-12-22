//
//  User.swift
//  ChatClient
//
//  Created by setuper on 22.12.2025.
//

import Foundation
import SwiftData

@Model
public class UserData {
    public var id: UUID
    public var email: String
    
    public init(id: UUID, email: String) {
        self.id = id
        self.email = email
    }
}
