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
        
        usersRoute.get { req async throws -> [User] in
            try await User.query(on: req.db).all()
        }
    }
}

private extension UserController {
    
}
