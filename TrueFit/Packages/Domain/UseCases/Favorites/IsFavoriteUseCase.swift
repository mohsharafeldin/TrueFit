//
//  IsFavoriteUseCase.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 03/07/2026.
//

import Foundation

final class IsFavoriteUseCase {
    private let repository: FavoritesRepositoryProtocol

    init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }

    func execute(productId: String) async throws -> Bool {
        try await repository.isFavorite(productId: productId)
    }
}

