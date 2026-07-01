//
//  ResetPasswordUseCase.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 01/07/2026.
//

import Foundation

public protocol ResetPasswordUseCaseProtocol {
    func execute(email: String) async throws
}

public final class ResetPasswordUseCase: ResetPasswordUseCaseProtocol {
    private let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }
    
    public func execute(email: String) async throws {
        try await authRepository.resetPassword(email: email)
    }
}
