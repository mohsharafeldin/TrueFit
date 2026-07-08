//
//  PaymentResult.swift
//  TrueFit
//
//  Created by AndrewMagdy on 05/07/2026.
//

import Foundation

// MARK: - Payment Result

public enum PaymentResult {
    case success
    case cancelled
    case failed(reason: String)
}

enum PaymentMethodType: Equatable {
    case applePay
    case cashOnDelivery
}

enum PaymentState: Equatable {
    case idle
    case processing
    case success
    case cancelled
    case failed(message: String)
}
