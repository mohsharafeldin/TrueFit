//
//  StubPaymentGateway.swift
//  TrueFit
//
//  Created by AndrewMagdy on 07/07/2026.
//

import PassKit

final class StubPaymentGateway: PaymentGatewayProtocol {

    enum Outcome {
        case alwaysApprove
        case alwaysDecline(DeclineReason)
        case random
    }

    private let outcome: Outcome

    init(outcome: Outcome = .alwaysApprove) {
        self.outcome = outcome
    }

    func charge(
        paymentToken: PKPaymentToken,
        amount: Decimal,
        currencyCode: String
    ) async throws -> ChargeResult {
        try await Task.sleep(nanoseconds: 800_000_000)

        switch outcome {
        case .alwaysApprove:
            return .approved
        case .alwaysDecline(let reason):
            return .declined(reason: reason)
        case .random:
            return Bool.random() ? .approved : .declined(reason: .insufficientFunds)
        }
    }
}
