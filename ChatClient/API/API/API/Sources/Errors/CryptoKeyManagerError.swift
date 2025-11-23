//
//  CryptoKeyManagerError.swift
//  API
//
//  Created by setuper on 09.10.2025.
//

import Foundation

public enum CryptoKeyManagerError: Error {
    
    case keyAgreementFailed(Error)
    case invalidSharedKey

    case sealFailed(Error)
    case invalidSealedBox
    
    case openFailed(Error)
    case invalidDecryptedData
    
    case encodePublicKey
}
