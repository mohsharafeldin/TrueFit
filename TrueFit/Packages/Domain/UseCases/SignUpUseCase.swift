//
//  SignUpUseCase.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 01/07/2026.
//

import Foundation

public protocol SignUpUseCaseProtocol {
    func execute(firstName: String, lastName: String, email: String, password: String) async throws -> AuthResult
}

public final class SignUpUseCase: SignUpUseCaseProtocol {
    private let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }
    
    public func execute(firstName: String, lastName: String, email: String, password: String) async throws -> AuthResult {
        return try await authRepository.signUp(firstName: firstName, lastName: lastName, email: email, password: password)
    }
}
