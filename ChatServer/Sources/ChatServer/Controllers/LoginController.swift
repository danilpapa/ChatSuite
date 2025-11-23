//
//  File.swift
//  ChatServer
//
//  Created by setuper on 25.09.2025.
//

import Vapor
import Foundation

struct UserIdResponse: Content {
    
    let id: UUID
}

struct EmailRequest: Content {
    
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case email = "user_email"
    }
}

struct LoginController: RouteCollection {
    
    func boot(routes: any RoutesBuilder) throws {
        routes.grouped("login").post(use: handleEmailAuth)
    }
    
    private func handleEmailAuth(_ req: Request) async throws -> UserIdResponse {
        do {
            let googleCredentials = try req.content.decode(GoogleCredentials.self)
            
            if let existingUser = try await User.query(on: req.db)
                .filter(\.$email, .equal, googleCredentials.email)
                .first() {
                
                if existingUser.firebaseToken != googleCredentials.firebaseToken {
                    existingUser.firebaseToken = googleCredentials.firebaseToken
                    try await existingUser.save(on: req.db)
                }
                
                guard let userId = existingUser.id else {
                    throw Abort(.internalServerError, reason: "User ID is missing")
                }
                return UserIdResponse(id: userId)
            } else {
                let newUser = User(
                    email: googleCredentials.email,
                    firebaseToken: googleCredentials.firebaseToken
                )
                try await newUser.save(on: req.db)
                
                guard let userId = newUser.id else {
                    throw Abort(.internalServerError, reason: "Error during user creation")
                }
                return UserIdResponse(id: userId)
            }
        } catch {
            throw Abort(.badRequest, reason: error.localizedDescription)
        }
    }
}
