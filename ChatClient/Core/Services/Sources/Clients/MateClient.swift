//
//  MateClient.swift
//  Services
//
//  Created by setuper on 23.11.2025.
//

import Foundation
import Alamofire
import Network
import Singleton
import API
import SwiftUI

@Singleton
public struct MateClient {
    
    public func getStatus(from id: UUID, to peerId: UUID) async throws -> MateStatus? {
        let request = ApiRequest<Never>(
            method: .get,
            url: EndPoints.users.appending("mate"),
            query: [
                "mate_id": peerId,
                "user_id": id
            ]
        )
        let response: ApiResponse<_MateStatus> = try await ApiClient.shared.perform(request: request)
        guard let mateStatus = MateStatus(rawValue: response.body.status) else {
            print(#file)
            return nil
        }
        return mateStatus
    }
    
    public func getMessageColor(to id: String) async throws -> Color {
        let request = ApiRequest<Never>(
            method: .get,
            url: EndPoints.mateMessageColor.path,
            query: [
                "mate_id": id
            ]
        )
        let response: ApiResponse<_MateMessageColor> = try await ApiClient.shared.perform(request: request)
        return .init(hex: response.body.hex) ?? .accentColor
    }
}

private struct _MateStatus: Decodable {
    let status: String
}

private struct _MateMessageColor: Decodable {
    var hex: String
}

private extension Color {
    
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
