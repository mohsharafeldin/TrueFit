//
//  FirebaseAuthDataSource.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 01/07/2026.
//

import Foundation
import FirebaseAuth

public final class FirebaseAuthDataSource: FirebaseAuthDataSourceProtocol {
    
    public init() {}
    
    public func signIn(email: String, password: String) async throws -> AuthDataResult {
        return try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    public func signUp(email: String, password: String) async throws -> AuthDataResult {
        return try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    public func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    public func deleteCurrentUser() async throws {
        guard let user = Auth.auth().currentUser else { return }
        try await user.delete()
    }
    
    public func signOut() throws {
        try Auth.auth().signOut()
    }
    
    public func sendEmailVerification() async throws {
        guard let user = Auth.auth().currentUser else { return }

           try await user.sendEmailVerification()

           
    }
    
    public func isEmailVerified() -> Bool {
        return Auth.auth().currentUser?.isEmailVerified ?? false
    }
}

