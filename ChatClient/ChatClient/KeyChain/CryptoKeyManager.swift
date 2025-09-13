//
//  CryptoKeyManager.swift
//  ChatClient
//
//  Created by setuper on 13.09.2025.
//

enum CryptoKeyType {
    
    case privateKey
}

enum CryptoError: Error {
    
    case encodeKey
    case save(CryptoKeyType)
    case get(CryptoKeyType)
    case delete(CryptoKeyType)
}

import Foundation

final class CryptoKeyManager {
    
    static let shared: CryptoKeyManager = .init()
    
    private let service: String
    
    private init(service: String = Bundle.main.bundleIdentifier ?? .cryptoStorageKey) {
        self.service = service
    }
    
    func save(key: String, type: CryptoKeyType) -> Result<Void, CryptoError> {
        guard let data = key.data(using: .utf8) else { return .failure(.encodeKey) }
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: "\(type)",
            kSecValueData: data,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked
        ]
        SecItemDelete(query as CFDictionary)
        if SecItemAdd(query as CFDictionary, nil) == errSecSuccess {
            return .success(())
        }
        return .failure(.save(type))
    }
    
    func get(type: CryptoKeyType) -> Result<String, CryptoError> {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: "\(type)",
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            guard let keyString = String(data: data, encoding: .utf8) else { return .failure(.get(type)) }
            return .success(keyString)
        }
        return .failure(.get(type))
    }
    
    func delete(type: CryptoKeyType) -> Result<Void, CryptoError> {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: "\(type)"
        ]

        if SecItemDelete(query as CFDictionary) == errSecSuccess {
            return .success(())
        }
        return .failure(.delete(type))
    }
}

private extension String {
    
    static let cryptoStorageKey = "CryptoStorage"
}
