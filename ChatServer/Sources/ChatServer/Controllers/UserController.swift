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
        let friendRequests = routes.grouped("friendRequest")
        let activeFriendsRequests = routes.grouped("activeFriends")
        let friednActionRequest = routes.grouped("friednActionRequest")
        
        usersRoute.group(":user_name_prefix") { usersRoute in
            usersRoute.post(use: handleUsersNamePreffixRequest)
        }
        usersRoute.group("mate") { mateStatusRoute in
            mateStatusRoute.get(use: handleMateStatusGetRequest)
        }
        recentLobbies.post(use: handleRecentLobbyRequest)
        friendRequests.get(use: handleFriendRequest)
        friednActionRequest.post(use: handleFriendPostRequest)
        activeFriendsRequests.get(use: handleActiveFriendsRequest)
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
    
    private func handleFriendPostRequest(_ req: Request) async throws -> HTTPStatus {
        guard let action = req.query[String.self, at: "action"] else {
            throw Abort(.badRequest, reason: "Error accesing action query param \(#file)")
        }
        let requestData: MateRequest
        do {
            requestData = try req.content.decode(MateRequest.self)
        } catch {
            throw Abort(.badRequest, reason: "Error accesing user id and peer id at body \(error.localizedDescription)")
        }
        if action == "Add mate" {
            let newRequest = MateRequests(
                from: requestData.userId,
                to: requestData.peerId,
                status: .pending
            )
            try await newRequest.save(on: req.db)
        } else if action == "Discard" {
            try await MateRequests.query(on: req.db)
                .group(.and) { group in
                    group.filter(\.$from.$id, .equal, requestData.peerId)
                    group.filter(\.$to.$id, .equal, requestData.userId)
                }
                .delete()
        } else if action == "Accept" {
            let request = try await MateRequests.query(on: req.db)
                .group(.and) { group in
                    group.filter(\.$from.$id, .equal, requestData.peerId)
                    group.filter(\.$to.$id, .equal, requestData.userId)
                }
                .first()
            request?.status = .accepted
        }
        return .accepted
    }
    
    private func handleFriendRequest(_ req: Request) async throws -> [User] {
        guard let userIdString = req.query[String.self, at: "user_id"],
              let id = UUID(uuidString: userIdString) else {
            throw Abort(.badRequest, reason: "Error accesing query params, \(#file)")
        }
        let mateRequests = try await MateRequests.query(on: req.db)
            .filter(\.$to.$id, .equal, id)
            .with(\.$from)
            .all()
        return mateRequests.map { request in
            request.from
        }
    }
    
    private func handleActiveFriendsRequest(_ req: Request) async throws -> [User] {
        guard let userIdString = req.query[String.self, at: "user_id"],
              let userId = UUID(uuidString: userIdString) else {
            throw Abort(.badRequest, reason: "Error accesing query params, \(#file), \(#function)")
        }
        do {
            let activeFriends = try await UserFriend.query(on: req.db)
                .group(.or) { group in
                    group.filter(\.$user.$id, .equal, userId)
                    group.filter(\.$friend.$id, .equal, userId)
                }
                .all()
            return activeFriends.map { userFriend in
                userFriend.user
            }
        } catch let error as PostgresNIO.PSQLError {
            return []
        } catch {
            throw Abort(.badRequest, reason: "Error executing operation: \(error.localizedDescription)")
        }
    }
}

fileprivate struct MateRequest: Content {
    
    let userId: UUID
    let peerId: UUID
    
    enum CodingKeys: String, CodingKey {
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
