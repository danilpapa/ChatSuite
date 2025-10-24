//
//  File.swift
//  ChatServer
//
//  Created by setuper on 10.10.2025.
//

import Vapor
import PostgresNIO

struct UserController: RouteCollection {
    
    func boot(routes: any RoutesBuilder) throws {
        let usersRoute = routes.grouped("user")
        let recentLobbies = routes.grouped("recentChats")
        
        usersRoute.get { req async throws -> [User] in
            try await User.query(on: req.db).all()
        }
        
        recentLobbies.post(use: handleRecentLobbyRequest)
    }
    
    private func handleRecentLobbyRequest(_ req: Request) async throws -> [RecentChats] {
        var userId: UUID
        do {
            userId = try req.content.decode(UserId.self).userId
        } catch {
            throw Abort(.badRequest, reason: "Error with user_id header: \(error.localizedDescription)")
        }
        do {
            return try await RecentChats
                .query(on: req.db)
                .group(.or, { group in
                    group.filter(\.$userHost1.$id, .equal, userId)
                    group.filter(\.$userHost2.$id, .equal, userId)
                })
                .all()
        } catch {
            if let _ = error as? PostgresNIO.PSQLError {
                return []
            } else {
                throw Abort(.badGateway, reason: error.localizedDescription)
            }
        }
    }
}

private extension UserController {
    
}
