//
//  PaymentViewModel.swift
//  TrueFit
//
//  Presentation — ViewModel for the Payment screen.
//  All business logic goes through use cases; the view is kept pure.
//

import Foundation
import PassKit

enum PaymentState: Equatable {
    case idle
    case processing
    case success
    case cancelled
    case failed(message: String)
}

@MainActor
final class PaymentViewModel: ObservableObject {

    @Published private(set) var paymentState: PaymentState = .idle
    @Published private(set) var isApplePayAvailable: Bool = false

    let orderTotal: Decimal
    let orderLabel: String

    private let processPayment: ProcessPaymentUseCase
    private let clearCartUseCase: ClearCartUseCase
    private var preferencesManager: PreferencesManagerProtocol
    private let cartStateModel: CartState

    init(
        processPaymentUseCase: ProcessPaymentUseCase,
        clearCartUseCase: ClearCartUseCase,
        preferencesManager: PreferencesManagerProtocol,
        cartStateModel: CartState,
        orderTotal: Decimal,
        orderLabel: String = "TrueFit Order"
    ) {
        self.processPayment = processPaymentUseCase
        self.clearCartUseCase = clearCartUseCase
        self.preferencesManager = preferencesManager
        self.cartStateModel = cartStateModel
        self.orderTotal = orderTotal
        self.orderLabel = orderLabel
        self.isApplePayAvailable = checkApplePayAvailability()
    }

    private func checkApplePayAvailability() -> Bool {
        PKPaymentAuthorizationController.canMakePayments(
            usingNetworks: PaymentConfiguration.supportedNetworks
        )
    }

    func startApplePayment() async {
        guard isApplePayAvailable else {
            paymentState = .failed(message: PaymentError.applePayUnavailable.errorDescription ?? "")
            return
        }

        guard orderTotal > 0 else {
            paymentState = .failed(message: PaymentError.invalidRequest.errorDescription ?? "")
            return
        }

        paymentState = .processing

        let summaryItem = PKPaymentSummaryItem(
            label: orderLabel,
            amount: NSDecimalNumber(decimal: orderTotal)
        )
        let merchantItem = PKPaymentSummaryItem(
            label: PaymentConfiguration.merchantDisplayName,
            amount: NSDecimalNumber(decimal: orderTotal)
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
            case .success:
                do {
                    if let cartId = preferencesManager.cartId, !cartId.isEmpty {
                        let emptyCart = try await clearCartUseCase.execute(cartId: cartId)
                        cartStateModel.updateCount(emptyCart.totalQuantity)
                    }
                } catch {
                    print("Failed to clear cart: \(error)")
                }
                paymentState = .success
            case .cancelled:  paymentState = .cancelled
            case .failed(let reason): paymentState = .failed(message: reason)
            }
        } catch let error as PaymentError {
            paymentState = .failed(message: error.errorDescription ?? "")
        } catch {
            paymentState = .failed(message: error.localizedDescription)
        }
    }

    func resetState() {
        paymentState = .idle
    }
}
