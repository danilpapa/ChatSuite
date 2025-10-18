//
//  File.swift
//  ChatServer
//
//  Created by setuper on 10.10.2025.
//

import Vapor

struct UserController: RouteCollection {
    
    func boot(routes: any RoutesBuilder) throws {
        let usersRoute = routes.grouped("user")
        let recentLobbies = routes.grouped("recentChats")
        
        usersRoute.get { req async throws -> [User] in
            try await User.query(on: req.db).all()
        }
        
        recentLobbies.get(use: handleRecentLobbyRequest)
    }
    
    // TODO: ебучий отладчик не попадает
    private func handleRecentLobbyRequest(_ req: Request) async throws -> [RecentChats] {
        do {
            guard
                let userIdString = req.query[String.self, at: "user_id"],
                let userId = UUID(uuidString: userIdString) else
            {
                throw Abort(.badRequest, reason: "Missing or invalid user_id query parameter")
            }
            return try await RecentChats
                .query(on: req.db)
                .group(.or, { group in
                    group.filter(\.$userHost1.$id, .equal, userId)
                    group.filter(\.$userHost2.$id, .equal, userId)
                })
                .all()
        } catch {
            throw Abort(.badRequest, reason: "Error with user_id header: \(error.localizedDescription)")
        }
    }
}

private extension UserController {
    
}
