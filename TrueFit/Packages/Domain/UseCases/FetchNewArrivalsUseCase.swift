//
//  FetchNewArrivalsUseCase.swift
//  TrueFit
//
//  Domain — Business logic for fetching newest products.
//

import Foundation

final class FetchNewArrivalsUseCase {

    private let repository: ProductsRepositoryProtocol

    init(repository: ProductsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(limit: Int = 10) async throws -> [Product] {
        try await repository.fetchNewArrivals(limit: limit)
    }
}
