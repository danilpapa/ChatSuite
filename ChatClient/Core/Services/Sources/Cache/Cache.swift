//
//  Cache.swift
//  HeedAssembly
//
//  Created by setuper on 13.12.2025.
//

import Foundation

enum Cache {
    
    static func invoke<Key: Hashable, Value: Codable>(
        key: Key,
        cache: NSCache<NSString, NSData>,
        loader: () async throws -> Value
    ) async throws -> Value {
        let keyString = String(describing: key) as NSString
        if let data = cache.object(forKey: keyString) {
            return try JSONDecoder().decode(Value.self, from: data as Data)
        }
        let value = try await loader()
        let data = try JSONEncoder().encode(value)
        cache.setObject(data as NSData, forKey: keyString)
        return value
    }
}
