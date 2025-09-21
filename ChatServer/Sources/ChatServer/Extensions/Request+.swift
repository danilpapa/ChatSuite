//
//  File.swift
//  ChatServer
//
//  Created by setuper on 20.09.2025.
//

import Vapor

extension Request {
    
    func valueForHeader(_ headerName: String) -> String? {
        self.headers.first { name, value in
            name == headerName
        }?.value
    }
}
