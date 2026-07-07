//
//  FetchBrandsUseCase.swift
//  TrueFit
//
//  Domain — Business logic for fetching available brands (vendors).
//

import Foundation

final class FetchBrandsUseCase {

    private let repository: ProductsRepositoryProtocol

    init(repository: ProductsRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Brand] {
        try await repository.fetchBrands()
    }
}
