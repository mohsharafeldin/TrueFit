//
//  ProcessPaymentUseCase.swift
//  TrueFit
//
//  Domain — Initiates and resolves a payment session.
//

import Foundation

// MARK: - Process Payment Use Case

/// Orchestrates a single payment attempt.
///
/// Follows the `callAsFunction` pattern used throughout the project
/// (see `GetAddressesUseCase`, `CreateAddressUseCase`).
struct ProcessPaymentUseCase {

    private let repository: PaymentRepositoryProtocol

    init(repository: PaymentRepositoryProtocol) {
        self.repository = repository
    }

    /// Execute the payment.
    ///
    /// - Parameter request: Merchant-configured payment request.
    /// - Returns: The `PaymentResult` produced by the payment sheet.
    func callAsFunction(request: PaymentRequestDTO) async throws -> PaymentResult {
        try await repository.processPayment(request: request)
    }
}
