//
//  FetchAllProductsUseCase.swift
//  TrueFit
//
//  Domain — Business logic for fetching all products for search & filtering.
//

import Foundation

final class FetchAllProductsUseCase {

    private let repository: ProductsRepositoryProtocol

    init(repository: ProductsRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Product] {
        try await repository.fetchAllProducts()
    }
}
