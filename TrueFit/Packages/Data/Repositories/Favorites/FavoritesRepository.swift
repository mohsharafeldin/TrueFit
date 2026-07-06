//
//  FavoritesRepository.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 04/07/2026.
//

import Foundation

final class FavoritesRepository: FavoritesRepositoryProtocol {
    private let localDataSource: FavoritesLocalDataSourceProtocol
    
    init(localDataSource: FavoritesLocalDataSourceProtocol) {
        self.localDataSource = localDataSource
    }
    
    func getAllFavorites() async throws -> [FavoriteItem] {
        let entities = try await localDataSource.fetchAll()
        return entities.map { FavoriteItemMapper.toDomain($0) }
    }
    
    func addFavorite(_ item: FavoriteItem) async throws {
        try await localDataSource.insert(item)
    }
    
    func removeFavorite(productId: String) async throws {
        try await localDataSource.delete(productId: productId)
    }
    
    func isFavorite(productId: String) async throws -> Bool {
        try await localDataSource.exists(productId: productId)
    }
}
