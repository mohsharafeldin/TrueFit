//
//  FetchProductsByCollectionUseCase.swift
//  TrueFit
//
//  Domain — Business logic for fetching products belonging to a collection.
//

import Foundation

final class FetchProductsByCollectionUseCase {

    private let repository: ProductsRepositoryProtocol

    init(repository: ProductsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(collectionId: Int64) async throws -> [Product] {
        try await repository.fetchProductsByCollection(collectionId: collectionId)
    }
}
