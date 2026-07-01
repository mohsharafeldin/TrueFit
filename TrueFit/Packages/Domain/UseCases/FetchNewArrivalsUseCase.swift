//
//  FetchNewArrivalsUseCase.swift
//  TrueFit
//
//  Domain — Business logic for fetching newest products.
//

import Foundation

final class FetchNewArrivalsUseCase {

    private let repository: HomeRepositoryProtocol

    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }

    func execute(limit: Int = 10) async throws -> [Product] {
        try await repository.fetchNewArrivals(limit: limit)
    }
}
