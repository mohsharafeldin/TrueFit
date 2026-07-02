//
//  AuthResult.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 01/07/2026.
//

import Foundation

public struct AuthResult: Equatable {
    public let user: User
    
    public init(user: User) {
        self.user = user
    }
}
