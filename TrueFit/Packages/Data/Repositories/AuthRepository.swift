//
//  AuthRepository.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 30/06/2026.
//

import Foundation

class AuthRepository: AuthRepositoryProtocol {
    func loginWithGoogle() async throws -> String {
        return "dummy_token_123"
    }
    
        
    func login(email: String, password: String) async throws -> String {
        // TODO: API Call
        return "dummy_token_123"
    }
    
    func signUp(firstName: String, lastName: String, email: String, password: String) async throws -> String {
        // TODO: API Call
        return "dummy_token_456"
    }
    
    func resetPassword(email: String) async throws {
        // TODO: API Call
    }
}
