//
//  SendEmailVerificationUseCase.swift
//  TrueFit
//

import Foundation

public protocol SendEmailVerificationUseCaseProtocol {
    func execute() async throws
}

public final class SendEmailVerificationUseCase: SendEmailVerificationUseCaseProtocol {
    private let authRepository: AuthRepositoryProtocol

    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }

    public func execute() async throws {
        try await authRepository.sendEmailVerification()
    }
}
