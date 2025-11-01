//
//  CryptoManager.swift
//  ChatClient
//
//  Created by setuper on 18.09.2025.
//

import Foundation
import CryptoKit
import FirebaseCrashlytics

typealias PrivateKey = Curve25519.KeyAgreement.PrivateKey
typealias PublicKey = Curve25519.KeyAgreement.PrivateKey.PublicKey

protocol ICryptoManager {
    
    var privateKey: PrivateKey { get }
    var publicKey: PublicKey { get }
    var sharedSymmetricKey: SymmetricKey! { get }
    
    mutating func updateOtherClientKey(_ key: PublicKey) throws
    
    func encryptMessage(_ message: Data) -> Result<Data, CryptoKeyManagerError>
    func decryptMessage(_ message: Data) -> Result<String, CryptoKeyManagerError>
}

struct CryptoManager: ICryptoManager {
    
    private(set) var privateKey: PrivateKey
    private(set) var publicKey: PublicKey
    private(set) var sharedSymmetricKey: SymmetricKey!
    
    private var otherClientKey: PublicKey?
    
    init() {
        privateKey = Curve25519.KeyAgreement.PrivateKey()
        publicKey = privateKey.publicKey
    }
    
    mutating func updateOtherClientKey(_ key: PublicKey) throws {
        otherClientKey = key
        let sharedKey = try privateKey.sharedSecretFromKeyAgreement(with: key)
        self.sharedSymmetricKey = sharedKey.hkdfDerivedSymmetricKey(
            using: SHA256.self,
            salt: Data(),
            sharedInfo: Data(),
            outputByteCount: 32
        )
    }
    
    func encryptMessage(_ message: Data) -> Result<Data, CryptoKeyManagerError> {
        do {
            let sealedBox = try AES.GCM.seal(message, using: self.sharedSymmetricKey)
            guard let combinedData = sealedBox.combined else {
                return .failure(.invalidSealedBox)
            }
            return .success(combinedData)
        } catch {
            Crashlytics.crashlytics().log("EncryptMessage failed")
            Crashlytics.crashlytics().record(error: error)
            return .failure(.sealFailed(error))
        }
    }
    
    func decryptMessage(_ message: Data) -> Result<String, CryptoKeyManagerError> {
        do {
            let sealedBoxToOpen = try AES.GCM.SealedBox(combined: message)
            do {
                let decryptedData = try AES.GCM.open(sealedBoxToOpen, using: sharedSymmetricKey)
                guard let decryptedMessage = String(data: decryptedData, encoding: .utf8) else {
                    return .failure(.invalidDecryptedData)
                }
                return .success(decryptedMessage)
            } catch {
                Crashlytics.crashlytics().log("Decryption failed while opening sealed box")
                Crashlytics.crashlytics().record(error: error)
                return .failure(.openFailed(error))
            }
        } catch {
            Crashlytics.crashlytics().log("Failed to create SealedBox from data")
            Crashlytics.crashlytics().record(error: error)
            return .failure(.sealFailed(error))
        }
    }
}
