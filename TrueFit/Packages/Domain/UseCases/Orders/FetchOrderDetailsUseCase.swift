//
//  FetchOrderDetailsUseCase.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import Foundation

final class FetchOrderDetailsUseCase {
    private let repository: OrdersRepositoryProtocol
    
    init(repository: OrdersRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(orderId: String) async throws -> OrderDetails {
        return try await repository.fetchOrderDetails(orderId: orderId)
    }
}
