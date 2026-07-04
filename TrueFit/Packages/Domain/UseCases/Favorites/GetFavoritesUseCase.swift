//
//  GetFavoritesUseCase.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 03/07/2026.
//

import Foundation

final class GetFavoritesUseCase {
    private let repository: FavoritesRepositoryProtocol

    init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [FavoriteItem] {
        try await repository.getAllFavorites()
    }
}

