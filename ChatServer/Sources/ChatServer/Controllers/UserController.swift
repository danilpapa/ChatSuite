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
        let usersRoute = routes.grouped("users")
        let recentLobbies = routes.grouped("recentChats")
        
        usersRoute.group(":user_name_prefix") { usersRoute in
            usersRoute.post(use: handleUsersNamePreffixRequest)
        }
        recentLobbies.post(use: handleRecentLobbyRequest)
    }
    
    private func handleUsersNamePreffixRequest(_ req: Request) async throws -> [User] {
        do {
            let userNamePreffix = try req.content.decode(UserNamePrefixModel.self).namePrefix
            if userNamePreffix.isEmpty {
                return []
            }
            let result = try await User
                .query(on: req.db)
                .filter(\.$email, .contains(inverse: false, .prefix), userNamePreffix)
                .all()
            return result
        } catch {
            throw Abort(.badRequest, reason: "Error via accesing user name preffix: " + error.localizedDescription)
        }
    }
    
    private func handleRecentLobbyRequest(_ req: Request) async throws -> [RecentChats] {
        do {
            let userId = try req.content.decode(UserId.self).userId
            
            return try await RecentChats
                .query(on: req.db)
                .group(.or) { group in
                    group.filter(\.$userHost1.$id, .equal, userId)
                    group.filter(\.$userHost2.$id, .equal, userId)
                }
                .all()
        } catch let error as DecodingError {
            throw Abort(.badRequest, reason: "Invalid request body: \(error.localizedDescription)")
        } catch let error as PostgresNIO.PSQLError {
            return []
        } catch {
            throw Abort(.badGateway, reason: "Unexpected error: \(error.localizedDescription)")
        }
    }
}

private extension UserController {
    
}
