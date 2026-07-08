//
//  PaymentRepositoryProtocol.swift
//  TrueFit
//
//  Created by AndrewMagdy on 05/07/2026.
//

import Foundation

// MARK: - Payment Repository Protocol

/// Abstraction over payment processing.
///
/// The domain layer depends on this protocol; the Data layer provides
/// the concrete implementation. This keeps PassKit out of the domain.
public protocol PaymentRepositoryProtocol {

    /// Process a payment using the supplied request configuration.
    ///
    /// - Parameter request: The configured payment request DTO.
    /// - Returns: The `PaymentResult` once the session completes.
    /// - Throws: `PaymentError` if the request cannot be initiated.
    func processPayment(request: PaymentRequestDTO) async throws -> PaymentResult
}
