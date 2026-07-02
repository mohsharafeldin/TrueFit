//
//  FirebaseAuthDataSourceProtocol.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 01/07/2026.
//

import Foundation
import FirebaseAuth

public protocol FirebaseAuthDataSourceProtocol {
    func signIn(email: String, password: String) async throws -> AuthDataResult
    func signUp(email: String, password: String) async throws -> AuthDataResult
    func resetPassword(email: String) async throws
    func deleteCurrentUser() async throws
    func signOut() throws
}

