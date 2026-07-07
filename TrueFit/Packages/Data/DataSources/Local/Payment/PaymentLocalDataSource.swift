//
//  PaymentLocalDataSource.swift
//  TrueFit
//
//  Created by AndrewMagdy on 06/07/2026.
//

import PassKit

final class PaymentLocalDataSource: NSObject, PaymentLocalDataSourceProtocol {

    private var continuation: CheckedContinuation<PaymentResult, Error>?
    private let gateway: PaymentGatewayProtocol

    private var pendingAmount: Decimal = 0
    private var pendingCurrencyCode: String = "USD"

    init(gateway: PaymentGatewayProtocol) {
        self.gateway = gateway
    }

    func present(request: PaymentRequestDTO) async throws -> PaymentResult {
        guard PKPaymentAuthorizationController.canMakePayments(
            usingNetworks: request.supportedNetworks
        ) else {
            throw PaymentError.applePayUnavailable
        }

        pendingAmount = request.paymentSummaryItems.last.map { Decimal(string: $0.amount.stringValue) ?? 0 } ?? 0
        pendingCurrencyCode = request.currencyCode

        let pkRequest = makePKRequest(from: request)
        let controller = PKPaymentAuthorizationController(paymentRequest: pkRequest)
        controller.delegate = self

        return try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.continuation = continuation
            controller.present { success in
                if !success {
                    continuation.resume(throwing: PaymentError.invalidRequest)
                    self?.continuation = nil
                }
            }
        }
    }

    private func makePKRequest(from dto: PaymentRequestDTO) -> PKPaymentRequest {
        let request = PKPaymentRequest()
        request.merchantIdentifier = dto.merchantIdentifier
        request.supportedNetworks = dto.supportedNetworks
        request.merchantCapabilities = dto.merchantCapabilities
        request.countryCode = dto.countryCode
        request.currencyCode = dto.currencyCode
        request.paymentSummaryItems = dto.paymentSummaryItems
        return request
    }
}

extension PaymentLocalDataSource: PKPaymentAuthorizationControllerDelegate {

    func paymentAuthorizationController(
        _ controller: PKPaymentAuthorizationController,
        didAuthorizePayment payment: PKPayment,
        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void
    ) {
        Task { [weak self] in
            guard let self else { return }

            do {
                let result = try await self.gateway.charge(
                    paymentToken: payment.token,
                    amount: self.pendingAmount,
                    currencyCode: self.pendingCurrencyCode
                )

                switch result {
                case .approved:
                    completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
                    self.continuation?.resume(returning: .success)

                case .declined(let reason):
                    let error = NSError(
                        domain: PKPaymentErrorDomain,
                        code: PKPaymentError.unknownError.rawValue,
                        userInfo: [NSLocalizedDescriptionKey: reason.message]
                    )
                    completion(PKPaymentAuthorizationResult(status: .failure, errors: [error]))
                    self.continuation?.resume(returning: .failed(reason: reason.message))
                }
            } catch let error as PaymentError {
                let nsError = NSError(
                    domain: PKPaymentErrorDomain,
                    code: PKPaymentError.unknownError.rawValue,
                    userInfo: [NSLocalizedDescriptionKey: error.errorDescription ?? "Payment failed."]
                )
                completion(PKPaymentAuthorizationResult(status: .failure, errors: [nsError]))
                self.continuation?.resume(returning: .failed(reason: error.errorDescription ?? "Payment failed."))
            } catch {
                let nsError = NSError(
                    domain: PKPaymentErrorDomain,
                    code: PKPaymentError.unknownError.rawValue,
                    userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]
                )
                completion(PKPaymentAuthorizationResult(status: .failure, errors: [nsError]))
                self.continuation?.resume(returning: .failed(reason: error.localizedDescription))
            }

            self.continuation = nil
        }
    }

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss { [weak self] in
            guard let self, let continuation = self.continuation else { return }
            continuation.resume(returning: .cancelled)
            self.continuation = nil
        }
    }
}
