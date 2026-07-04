//
//  LoginWithGoogleUseCase.swift
//  TrueFit
//
//  Created by AndrewMagdy on 03/07/2026.
//

import Foundation
final class LoginWithGoogleUseCase: LoginWithGoogleUseCaseProtocol {
   
    
    private let authRepository: AuthRepositoryProtocol

    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }

    func execute() async throws -> AuthResult {
        try await authRepository.loginWithGoogle()
    }
}
