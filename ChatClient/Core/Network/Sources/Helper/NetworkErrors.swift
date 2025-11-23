//
//  NetworkErrors.swift
//  HeedAssembly
//
//  Created by setuper on 23.11.2025.
//

import Foundation

public enum NetworkError_: Error {
    
    case incorrectEmail
    case obtainingUsersError(String)
    case loginRequest(String)
    case loginError(String)
    case mateStatusError(String)
}
