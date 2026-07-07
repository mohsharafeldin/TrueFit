//
//  PaymentError.swift
//  TrueFit
//
//  Created by AndrewMagdy on 05/07/2026.
//
import Foundation

// MARK: - Payment Error

/// Errors that can arise during payment processing.
public enum PaymentError: LocalizedError {

    case applePayUnavailable

    case invalidRequest

    case paymentDeclined

    case unknown(String)


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
