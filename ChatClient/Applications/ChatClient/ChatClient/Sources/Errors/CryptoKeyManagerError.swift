//
//  CryptoKeyManagerError.swift
//  ChatClient
//
//  Created by setuper on 09.10.2025.
//

import Foundation

enum CryptoKeyManagerError: Error {
    
    case keyAgreementFailed(Error)
    case invalidSharedKey

    case sealFailed(Error)
    case invalidSealedBox
    
    case openFailed(Error)
    case invalidDecryptedData
    
    case encodePublicKey
}
