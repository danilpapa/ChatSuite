//
//  ICryptoManager.swift
//  API
//
//  Created by setuper on 09.10.2025.
//

import CryptoKit
import Foundation

public typealias PrivateKey = Curve25519.KeyAgreement.PrivateKey
public typealias PublicKey = Curve25519.KeyAgreement.PrivateKey.PublicKey

public protocol ICryptoManager {
    
    var privateKey: PrivateKey { get }
    var publicKey: PublicKey { get }
    var sharedSymmetricKey: SymmetricKey! { get }
    
    mutating func updateOtherClientKey(_ key: PublicKey) throws
    
    func encryptMessage(_ message: Data) throws(CryptoKeyManagerError) -> Data
    func decryptMessage(_ message: Data) throws(CryptoKeyManagerError) -> String
}
