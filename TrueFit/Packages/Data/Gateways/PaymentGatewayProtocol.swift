//
//  PaymentGatewayProtocol.swift
//  TrueFit
//
//  Created by AndrewMagdy on 07/07/2026.
//

import PassKit

protocol PaymentGatewayProtocol {
    func charge(
        paymentToken: PKPaymentToken,
        amount: Decimal,
        currencyCode: String
    ) async throws -> ChargeResult
}

enum ChargeResult {
    case approved
    case declined(reason: DeclineReason)
}

enum DeclineReason {
    case insufficientFunds
    case cardExpired
    case cardNotSupported
    case generic(message: String)

    var message: String {
        switch self {
        case .insufficientFunds:
            return "Your card has insufficient funds."
        case .cardExpired:
            return "Your card has expired."
        case .cardNotSupported:
            return "This card cannot be used for this purchase."
        case .generic(let message):
            return message
        }
    }
}
