//
//  FetchOrdersUseCase.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import Foundation

final class FetchOrdersUseCase {
    private let repository: OrdersRepositoryProtocol
    
    init(repository: OrdersRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [Order] {
        return try await repository.fetchOrders()
    }
}
