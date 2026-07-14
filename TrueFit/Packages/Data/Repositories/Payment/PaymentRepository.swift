//
//  PaymentRepository.swift
//  TrueFit
//
//  Created by AndrewMagdy on 06/07/2026.
//
import Foundation


final class PaymentRepository: PaymentRepositoryProtocol {

    // MARK: - Dependencies

    private let dataSource: PaymentLocalDataSourceProtocol

    // MARK: - Init

    init(dataSource: PaymentLocalDataSourceProtocol) {
        self.dataSource = dataSource
    }

    // MARK: - PaymentRepositoryProtocol

    func processPayment(request: PaymentRequestDTO) async throws -> PaymentResult {
        try await dataSource.present(request: request)
    }
}
