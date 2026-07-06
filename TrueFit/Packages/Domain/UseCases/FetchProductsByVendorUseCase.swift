//
//  FetchProductsByVendorUseCase.swift
//  TrueFit
//
//  Domain — Business logic for fetching products belonging to a specific vendor/brand.
//

import Foundation

final class FetchProductsByVendorUseCase {

    private let repository: ProductsRepositoryProtocol

    init(repository: ProductsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(vendor: String) async throws -> [Product] {
        try await repository.fetchProductsByVendor(vendor: vendor)
    }
}
