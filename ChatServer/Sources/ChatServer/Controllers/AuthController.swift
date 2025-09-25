//
//  File.swift
//  ChatServer
//
//  Created by setuper on 25.09.2025.
//

import Vapor

struct UserIdResponse: Content {
    
    let id: String
}

struct EmailRequest: Content {
    
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case email = "user_email"
    }
}

struct AuthController: RouteCollection {
    
    func boot(routes: any RoutesBuilder) throws {
        routes.grouped("email_auth").post(use: handleEmailAuth)
    }
    
    private func handleEmailAuth(_ req: Request) async throws -> UserIdResponse {
        do {
            let email = try req.content.decode(EmailRequest.self).email
            let user = User(email: email)
            try await user.save(on: req.db)
            guard let userId = user.id else { throw Abort(.badRequest) }
            return .init(id: userId.uuidString)
        } catch {
            throw Abort(.badRequest, reason: error.localizedDescription)
        }
    }
}
