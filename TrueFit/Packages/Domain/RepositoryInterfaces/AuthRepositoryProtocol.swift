//
//  AuthRepositoryProtocol.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 30/06/2026.
//

import Foundation

protocol AuthRepositoryProtocol {
    func login(email: String, password: String) async throws -> AuthResult
    func signUp(firstName: String, lastName: String, email: String, password: String) async throws -> AuthResult
    func resetPassword(email: String) async throws
    func signOut() async throws
    func loginWithGoogle() async throws -> String
}
