//
//  AuthRepositoryProtocol.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 30/06/2026.
//

import Foundation

protocol AuthRepositoryProtocol {
    func login(email: String, password: String) async throws -> String
    func signUp(firstName: String, lastName: String, email: String, password: String) async throws -> String
    func resetPassword(email: String) async throws -> Void
    func loginWithGoogle() async throws -> String
}
