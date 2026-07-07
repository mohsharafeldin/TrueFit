//
//  ProcessPaymentUseCase.swift
//  TrueFit
//
//  Domain — Initiates and resolves a payment session.
//
//
//  ProcessPaymentUseCase.swift
//  TrueFit
//
//  Created by AndrewMagdy on 05/07/2026.
//

import Foundation

// MARK: - Process Payment Use Case

struct ProcessPaymentUseCase {

    private let repository: PaymentRepositoryProtocol

    init(repository: PaymentRepositoryProtocol) {
        self.repository = repository
    }
    
    func callAsFunction(request: PaymentRequestDTO) async throws -> PaymentResult {
        try await repository.processPayment(request: request)
    }
}
