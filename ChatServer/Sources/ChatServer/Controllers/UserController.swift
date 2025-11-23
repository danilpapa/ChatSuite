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
        usersRoute.group("mate") { mateStatusRoute in
            mateStatusRoute.get(use: handleMateStatusGetRequest)
            mateStatusRoute.post(use: handleMateStatusPostRequest)
        }
        
        recentLobbies.post(use: handleRecentLobbyRequest)
    }
    
    private func handleUsersNamePreffixRequest(_ req: Request) async throws -> [User] {
        do {
            let preffixModel = try req.content.decode(UserPreffixModel.self)
            if preffixModel.namePrefix.isEmpty { return [] }
            let result = try await User
                .query(on: req.db)
                .filter(\.$email, .contains(inverse: false, .prefix), preffixModel.namePrefix)
                .filter(\.$id, .notEqual, preffixModel.senderId)
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
    
    private func handleMateStatusGetRequest(_ req: Request) async throws -> MateStatus {
        guard let mateIdString = req.query[String.self, at: "mate_id"],
              let userIdString = req.query[String.self, at: "user_id"],
              let mateId = UUID(uuidString: mateIdString),
              let userId = UUID(uuidString: userIdString)
        else {
            throw Abort(
                .badRequest,
                reason: "Missing or invalid 'mate_id', 'user_id' parameter"
            )
        }
        let mateRequest = try await MateRequests.query(on: req.db)
            .group(.or) { group in
                group.group(.and) { group in
                    group.filter(\.$from.$id, .equal, userId)
                    group.filter(\.$to.$id, .equal, mateId)
                }
                group.group(.and) { group in
                    group.filter(\.$to.$id, .equal, userId)
                    group.filter(\.$from.$id, .equal, mateId)
                }
            }
            .all()
        if mateRequest.isEmpty {
            return MateStatus("Add mate")
        }
        guard let request = mateRequest.first else {
            throw Abort(.badRequest, reason: "Error via accesing Mate Request relation")
        }
        if request.status == .rejected {
            try await request.delete(on: req.db)
            return MateStatus("Add mate")
        }
        if request.$from.id == userId {
            return MateStatus(request.status.requestFromStatus)
        }
        if request.$to.id == userId {
            return MateStatus(request.status.requestToStatus)
        }
        return MateStatus("")
    }
    
    private func handleMateStatusPostRequest(_ req: Request) async throws -> String {
        let data: MateRequest
        do {
            data = try req.content.decode(MateRequest.self)
        } catch {
            throw Abort(.badRequest, reason: "Error via enconding body: \(error.localizedDescription)")
        }
        let currentMateState = data.state
        if currentMateState == "Add mate" {
            let newMateRequest = MateRequests(from: data.userId, to: data.peerId)
            try await newMateRequest.save(on: req.db)
        } else if currentMateState == "Pending" {
            
        } else if currentMateState == "Delete mate" {
            // TODO: Delete friend
            try await MateRequests.query(on: req.db)
                .group(.and) { group in
                    group.filter(\.$from.$id, .equal, data.userId)
                    group.filter(\.$to.$id, .equal, data.peerId)
                }
                .delete()
        } else if currentMateState == "Accept mate" {
            let request = try await MateRequests.query(on: req.db)
                .group(.and) { group in
                    group.filter(\.$from.$id, .equal, data.userId)
                    group.filter(\.$to.$id, .equal, data.peerId)
                }
                .first()
            request?.status = .accepted
            // TODO: Add fried
        }
        return "hello"
    }
}

fileprivate struct MateRequest: Content {
    
    let state: String
    let userId: UUID
    let peerId: UUID
    
    enum CodingKeys: String, CodingKey {
        case state = "request_status"
        case userId = "user_id"
        case peerId = "peer_id"
    }
}

private struct MateStatus: Content {
    
    let status: String
    
    init(_ status: String) {
        self.status = status
    }
}
