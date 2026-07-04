//
//  FavoritesRepositoryProtocol.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 03/07/2026.
//

import Foundation

protocol FavoritesRepositoryProtocol {
    func getAllFavorites() async throws -> [FavoriteItem]
    func addFavorite(_ item: FavoriteItem) async throws
    func removeFavorite(productId: String) async throws
    func isFavorite(productId: String) async throws -> Bool
}

