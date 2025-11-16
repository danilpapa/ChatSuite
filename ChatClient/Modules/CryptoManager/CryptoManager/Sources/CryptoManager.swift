//
//  CryptoManager.swift
//  CryptoManager
//
//  Created by setuper on 18.09.2025.
//

import Foundation
import CryptoKit
import CryptoAPI

public struct CryptoManager: ICryptoManager {
    
    public var privateKey: PrivateKey
    public var publicKey: PublicKey
    public var sharedSymmetricKey: SymmetricKey!
    
    private var otherClientKey: PublicKey?
    
    public init() {
        privateKey = Curve25519.KeyAgreement.PrivateKey()
        publicKey = privateKey.publicKey
    }
    
    public mutating func updateOtherClientKey(_ key: PublicKey) throws {
        otherClientKey = key
        let sharedKey = try privateKey.sharedSecretFromKeyAgreement(with: key)
        self.sharedSymmetricKey = sharedKey.hkdfDerivedSymmetricKey(
            using: SHA256.self,
            salt: Data(),
            sharedInfo: Data(),
            outputByteCount: 32
        )
    }
    
    public func encryptMessage(_ message: Data) throws(CryptoKeyManagerError) -> Data {
        do {
            let sealedBox = try AES.GCM.seal(message, using: self.sharedSymmetricKey)
            guard let combinedData = sealedBox.combined else {
                throw CryptoKeyManagerError.invalidSealedBox
            }
            return combinedData
        } catch {
            throw CryptoKeyManagerError.sealFailed(error)
        }
    }
    
    public func decryptMessage(_ message: Data) throws(CryptoKeyManagerError) -> String {
        do {
            let sealedBoxToOpen = try AES.GCM.SealedBox(combined: message)
            do {
                let decryptedData = try AES.GCM.open(sealedBoxToOpen, using: sharedSymmetricKey)
                guard let decryptedMessage = String(data: decryptedData, encoding: .utf8) else {
                    throw CryptoKeyManagerError.invalidDecryptedData
                }
                return decryptedMessage
            } catch {
                throw CryptoKeyManagerError.openFailed(error)
            }
        } catch {
            throw CryptoKeyManagerError.sealFailed(error)
        }
    }
}
