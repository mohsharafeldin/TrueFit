//
//  PaymentLocalDataSource.swift
//  TrueFit
//
//  Created by AndrewMagdy on 06/07/2026.
//

import PassKit

// MARK: - Payment Local Data Source

final class PaymentLocalDataSource: NSObject, PaymentLocalDataSourceProtocol {

    // MARK: - State

   
    private var continuation: CheckedContinuation<PaymentResult, Error>?

    // MARK: - PaymentLocalDataSourceProtocol

    func present(request: PaymentRequestDTO) async throws -> PaymentResult {
        guard PKPaymentAuthorizationController.canMakePayments(
            usingNetworks: request.supportedNetworks
        ) else {
            throw PaymentError.applePayUnavailable
        }

        let pkRequest = makePKRequest(from: request)

        let controller = PKPaymentAuthorizationController(paymentRequest: pkRequest)
        controller.delegate = self

        return try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.continuation = continuation
            controller.present(completion: nil)
        }
    }

    // MARK: - Private Helpers

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

// MARK: - PKPaymentAuthorizationControllerDelegate

extension PaymentLocalDataSource: PKPaymentAuthorizationControllerDelegate {

    func paymentAuthorizationController(
        _ controller: PKPaymentAuthorizationController,
        didAuthorizePayment payment: PKPayment,
        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void
    ) {
        
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            
            self.continuation?.resume(returning: .cancelled)
            self.continuation = nil
        }
    }

    func paymentAuthorizationController(
        _ controller: PKPaymentAuthorizationController,
        didAuthorizePayment payment: PKPayment,
        completion: @escaping (PKPaymentAuthorizationStatus) -> Void
    ) {
        completion(.success)
        continuation?.resume(returning: .success)
        continuation = nil
    }
}
