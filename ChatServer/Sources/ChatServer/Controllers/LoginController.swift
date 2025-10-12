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

struct LoginController: RouteCollection {
    
    func boot(routes: any RoutesBuilder) throws {
        routes.grouped("login").post(use: handleEmailAuth)
    }
    
    private func handleEmailAuth(_ req: Request) async throws -> String {
        do {
            let email = try req.content.decode(GoogleCredentials.self).email
            return "success"
        } catch {
            throw Abort(.badRequest, reason: error.localizedDescription)
        }
    }
}
