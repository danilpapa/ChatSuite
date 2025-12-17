//
//  File.swift
//  ChatServer
//
//  Created by setuper on 17.12.2025.
//

import Vapor

struct BDUIController: RouteCollection {
    
    func boot(routes: any RoutesBuilder) throws {
        routes.grouped("mateMessageColor").get(use: handleMessageColorUI)
    }
    
    private func handleMessageColorUI(_ req: Request) async throws -> _MateMessageColor {
        let now = Date().timeIntervalSince1970
        let milliseconds = Int(now * 1000)
        
        let seed = UInt64(milliseconds)
        let a: UInt64 = 6364136223846793005
        let c: UInt64 = 1442695040888963407
        let random = (a &* seed &+ c) & 0xFFFFFF
        
        let hexString = String(format: "%06llx", random).uppercased()
        let hexColor = "#\(hexString)"
        
        return _MateMessageColor(hex: hexColor)
    }
}

private struct _MateMessageColor: Content {
    
    var hex: String
}
