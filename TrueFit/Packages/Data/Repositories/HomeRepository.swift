//
//  HomeRepository.swift
//  TrueFit
//
//  Data — Implements HomeRepositoryProtocol, coordinates data sources and mappers.
//

import Foundation

final class HomeRepository: HomeRepositoryProtocol {

    private let remoteDataSource: HomeRemoteDataSourceProtocol

    init(remoteDataSource: HomeRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    // MARK: - Fetch New Arrivals

    func fetchNewArrivals(limit: Int) async throws -> [Product] {
        let dtos = try await remoteDataSource.fetchProducts(
            limit: limit,
            sortKey: "created_at"
        )
        return ProductMapper.map(dtos)
    }

    // MARK: - Fetch Collections

    func fetchCollections() async throws -> [ProductCollection] {
        // Fetch both smart and custom collections concurrently
        async let smartDTOs = remoteDataSource.fetchSmartCollections()
        async let customDTOs = remoteDataSource.fetchCustomCollections()

        let allDTOs = try await smartDTOs + customDTOs

        // Map to domain entities and fetch product counts concurrently
        var collections: [ProductCollection] = []

        await withTaskGroup(of: ProductCollection?.self) { group in
            for dto in allDTOs {
                group.addTask { [weak self] in
                    guard let self else { return nil }
                    let count = (try? await self.remoteDataSource.fetchProductsCount(collectionId: dto.id)) ?? dto.productsCount ?? 0
                    return CollectionMapper.map(dto, productsCount: count)
                }
            }

            for await collection in group {
                if let collection {
                    collections.append(collection)
                }
            }
        }

        return collections
    }
}
