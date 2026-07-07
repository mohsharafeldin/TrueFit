//
//  PaymentError.swift
//  TrueFit
//
//  Domain-level errors for the Payment feature.
//

import Foundation

// MARK: - Payment Error

/// Errors that can arise during payment processing.
public enum PaymentError: LocalizedError {

    /// Apple Pay is not available on this device or no cards are set up.
    case applePayUnavailable

    /// The payment request could not be formed (e.g. bad config).
    case invalidRequest

    /// The payment was declined by the network or issuer.
    case paymentDeclined

    /// An unknown error occurred, with an optional underlying message.
    case unknown(String)

    // MARK: LocalizedError

    public var errorDescription: String? {
        switch self {
        case .applePayUnavailable:
            return "Apple Pay is not available on this device."
        case .invalidRequest:
            return "The payment request could not be prepared."
        case .paymentDeclined:
            return "Your payment was declined. Please try a different card."
        case .unknown(let message):
            return message.isEmpty ? "An unexpected payment error occurred." : message
        }
    }
}
