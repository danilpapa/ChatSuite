//
//  MateRequests.swift
//  ChatServer
//
//  Created by setuper on 02.11.2025.
//

import Foundation
import Fluent
import Vapor

enum RequestStatus: String, Codable, Sendable {
    
    case pending
    case accepted
    case rejected
}

final class MateRequests: Model, @unchecked Sendable {
    static let schema = String.MateRequests.schema
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: String.MateRequests.Fields.from.literal)
    var from: User
    
    @Parent(key: String.MateRequests.Fields.to.literal)
    var to: User
    
    @Field(key: String.MateRequests.Fields.status.literal)
    var status: RequestStatus
    
    init() { }
    
    init(
        id: UUID? = nil,
        from: UUID,
        to: UUID,
        status: RequestStatus = .pending
    ) {
        self.id = id
        self.$from.id = from
        self.$to.id = to
        self.status = status
    }
}

extension String {
    
    enum MateRequests {
        
        static let schema = "mateRequests"
        
        enum Fields {
            
            static let from = "from"
            static let to = "to"
            static let status = "status"
        }
    }
}

extension RequestStatus {
    
    func statusForSender() -> MateActionStatus {
        switch self {
        case .pending:
            return .pending
        case .accepted:
            return .deleteMate
        case .rejected:
            return .addMate
        }
    }
    
    func statusForReceiver() -> MateActionStatus {
        switch self {
        case .pending:
            return .expectation
        case .accepted:
            return .deleteMate
        case .rejected:
            return .addMate
        }
    }
}
