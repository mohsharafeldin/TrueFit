//
//  ToggleFavoriteUseCase.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 03/07/2026.
//

import Foundation

final class ToggleFavoriteUseCase {
    private let repository: FavoritesRepositoryProtocol

    init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }

    func execute(item: FavoriteItem) async throws -> Bool {
        let exists = try await repository.isFavorite(productId: item.id)
        if exists {
            try await repository.removeFavorite(productId: item.id)
            return false
        } else {
            try await repository.addFavorite(item)
            return true
        }
    }
}
