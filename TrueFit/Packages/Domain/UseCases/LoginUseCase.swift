//
//  LoginUseCase.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 01/07/2026.
//

import Foundation

public protocol LoginUseCaseProtocol {
    func execute(email: String, password: String) async throws -> AuthResult
}

public final class LoginUseCase: LoginUseCaseProtocol {
    private let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }
    
    public func execute(email: String, password: String) async throws -> AuthResult {
        return try await authRepository.login(email: email, password: password)
    }
}
