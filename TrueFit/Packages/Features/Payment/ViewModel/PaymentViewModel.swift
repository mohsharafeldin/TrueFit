//
//  PaymentViewModel.swift
//  TrueFit
//
//  Presentation — ViewModel for the Payment screen.
//  All business logic goes through use cases; the view is kept pure.
//

import Foundation
import PassKit

// MARK: - Payment State

/// Represents every possible state of the payment flow.
enum PaymentState: Equatable {
    /// No payment has been initiated.
    case idle
    /// The Apple Pay sheet is being presented.
    case processing
    /// The payment completed successfully.
    case success
    /// The user dismissed the sheet without paying.
    case cancelled
    /// The payment failed with a user-facing message.
    case failed(message: String)
}

// MARK: - Payment ViewModel

@MainActor
final class PaymentViewModel: ObservableObject {

    // MARK: - Published State

    @Published private(set) var paymentState: PaymentState = .idle
    @Published private(set) var isApplePayAvailable: Bool = false

    // MARK: - Dependencies

    private let processPayment: ProcessPaymentUseCase

    // MARK: - Init

    init(processPaymentUseCase: ProcessPaymentUseCase) {
        self.processPayment = processPaymentUseCase
        self.isApplePayAvailable = checkApplePayAvailability()
    }

    // MARK: - Apple Pay Availability

    /// Checks both device hardware support and configured payment cards.
    private func checkApplePayAvailability() -> Bool {
        PKPaymentAuthorizationController.canMakePayments(
            usingNetworks: PaymentConfiguration.supportedNetworks
        )
    }

    // MARK: - Actions

    /// Initiates the Apple Pay payment sheet.
    ///
    /// Builds a `PaymentRequestDTO` from `PaymentConfiguration` constants,
    /// delegates processing to the use case, and updates `paymentState`
    /// based on the result. The view never inspects the DTO directly.
    func startApplePayment(totalAmount: Decimal, label: String) async {
        guard isApplePayAvailable else {
            paymentState = .failed(message: PaymentError.applePayUnavailable.errorDescription ?? "")
            return
        }

        paymentState = .processing

        let summaryItem = PKPaymentSummaryItem(
            label: label,
            amount: NSDecimalNumber(decimal: totalAmount)
        )
        let merchantItem = PKPaymentSummaryItem(
            label: PaymentConfiguration.merchantDisplayName,
            amount: NSDecimalNumber(decimal: totalAmount)
        )

        let dto = PaymentRequestDTO(
            merchantIdentifier: PaymentConfiguration.merchantIdentifier,
            supportedNetworks: PaymentConfiguration.supportedNetworks,
            merchantCapabilities: PaymentConfiguration.merchantCapabilities,
            countryCode: PaymentConfiguration.countryCode,
            currencyCode: PaymentConfiguration.currencyCode,
            paymentSummaryItems: [summaryItem, merchantItem]
        )

        do {
            let result = try await processPayment(request: dto)
            switch result {
            case .success:    paymentState = .success
            case .cancelled:  paymentState = .cancelled
            case .failed(let reason): paymentState = .failed(message: reason)
            }
        } catch let error as PaymentError {
            paymentState = .failed(message: error.errorDescription ?? "")
        } catch {
            paymentState = .failed(message: error.localizedDescription)
        }
    }

    /// Resets the payment state back to `.idle` so the user can try again.
    func resetState() {
        paymentState = .idle
    }
}
