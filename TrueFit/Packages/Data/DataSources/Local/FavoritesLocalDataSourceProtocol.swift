//
//  FavoritesLocalDataSourceProtocol.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 04/07/2026.
//

import Foundation

protocol FavoritesLocalDataSourceProtocol {
    func fetchAll() async throws -> [FavoriteItemEntity]
    func insert(_ item: FavoriteItem) async throws
    func delete(productId: String) async throws
    func exists(productId: String) async throws -> Bool
}
