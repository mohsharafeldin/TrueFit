//
//  PaymentViewModel.swift
//  TrueFit
//
//  Presentation — ViewModel for the Payment screen.
//  All business logic goes through use cases; the view is kept pure.
//

import Foundation
import PassKit



@MainActor
final class PaymentViewModel: ObservableObject {

    @Published private(set) var paymentState: PaymentState = .idle
    @Published private(set) var isApplePayAvailable: Bool = false
    @Published var selectedPaymentMethod: PaymentMethodType = .applePay

    let orderTotal: Decimal
    let orderLabel: String

    private let processPayment: ProcessPaymentUseCase
    private let getCartUseCase: GetCartUseCase
    private let removeCartLineUseCase: RemoveCartLineUseCase
    private var preferencesManager: PreferencesManagerProtocol
    private let cartStateModel: CartState

    init(
        processPaymentUseCase: ProcessPaymentUseCase,
        getCartUseCase: GetCartUseCase,
        removeCartLineUseCase: RemoveCartLineUseCase,
        preferencesManager: PreferencesManagerProtocol,
        cartStateModel: CartState,
        orderTotal: Decimal,
        orderLabel: String = "TrueFit Order"
    ) {
        self.processPayment = processPaymentUseCase
        self.getCartUseCase = getCartUseCase
        self.removeCartLineUseCase = removeCartLineUseCase
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

        let convertedAmount = CurrencyManager.shared.convert(orderTotal)
        let currencyCode = CurrencyManager.shared.selectedCurrency

        let summaryItem = PKPaymentSummaryItem(
            label: orderLabel,
            amount: NSDecimalNumber(decimal: convertedAmount)
        )
        let merchantItem = PKPaymentSummaryItem(
            label: PaymentConfiguration.merchantDisplayName,
            amount: NSDecimalNumber(decimal: convertedAmount)
        )

        let dto = PaymentRequestDTO(
            merchantIdentifier: PaymentConfiguration.merchantIdentifier,
            supportedNetworks: PaymentConfiguration.supportedNetworks,
            merchantCapabilities: PaymentConfiguration.merchantCapabilities,
            countryCode: PaymentConfiguration.countryCode,
            currencyCode: currencyCode,
            paymentSummaryItems: [summaryItem, merchantItem]
        )

        do {
            let result = try await processPayment(request: dto)
            switch result {
            case .success:
                await handlePaymentSuccess()
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

    private func handlePaymentSuccess() async {
        do {
            if let cartId = preferencesManager.cartId, !cartId.isEmpty {
                var cart = try await getCartUseCase.execute(cartId: cartId)
                for line in cart.lines {
                    cart = try await removeCartLineUseCase.execute(cartId: cartId, lineId: line.id)
                }
                cartStateModel.updateCount(cart.totalQuantity)
            }
        } catch {
            print("Failed to clear cart: \(error)")
        }
        paymentState = .success
    }

    func startCashOnDelivery() async {
        guard orderTotal > 0 else {
            paymentState = .failed(message: PaymentError.invalidRequest.errorDescription ?? "")
            return
        }

        paymentState = .processing
        try? await Task.sleep(nanoseconds: 800_000_000)
        await handlePaymentSuccess()
    }
}
