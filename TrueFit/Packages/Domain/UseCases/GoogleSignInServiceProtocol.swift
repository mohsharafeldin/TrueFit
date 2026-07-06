//
//  GoogleSignInServiceProtocol.swift
//  TrueFit
//
//  Created by AndrewMagdy on 03/07/2026.
//

import Foundation
public protocol GoogleSignInServiceProtocol {
    @MainActor
    func signIn() async throws -> GoogleSignInResult
}
