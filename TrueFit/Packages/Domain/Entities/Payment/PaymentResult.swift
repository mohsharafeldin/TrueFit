//
//  PaymentResult.swift
//  TrueFit
//
//  Created by AndrewMagdy on 05/07/2026.
//

import Foundation

// MARK: - Payment Result

/// The outcome of a completed payment session.
public enum PaymentResult {
    /// The payment was authorised and completed successfully.
    case success
    /// The user cancelled the payment sheet without completing.
    case cancelled
    /// The payment failed with a human-readable reason.
    case failed(reason: String)
}
