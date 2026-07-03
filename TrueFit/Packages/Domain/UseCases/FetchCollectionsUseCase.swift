//
//  FetchCollectionsUseCase.swift
//  TrueFit
//
//  Domain — Business logic for fetching product collections/categories.
//

import Foundation

final class FetchCollectionsUseCase {

    private let repository: ProductsRepositoryProtocol

    init(repository: ProductsRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [ProductCollection] {
        try await repository.fetchCollections()
    }
}
