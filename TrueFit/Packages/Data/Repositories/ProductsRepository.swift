//
//  ProductsRepository.swift
//  TrueFit
//
//  Data — Implements ProductsRepositoryProtocol, coordinates data sources and mappers.
//

import Foundation

final class ProductsRepository: ProductsRepositoryProtocol {

    private let remoteDataSource: ProductsRemoteDataSourceProtocol

    init(remoteDataSource: ProductsRemoteDataSourceProtocol) {
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
    
    
    func getProduct(id: String) async throws -> Product {
        // [Future CoreData Caching Layer]
        // Example:
        // if let cachedProduct = try? await localDataSource.getProduct(id: id) {
        //     return cachedProduct
        // }
        
        do {
            let productDTO = try await remoteDataSource.fetchProduct(id: id)
            let product = ProductMapper.map(productDTO)
            
            // [Future CoreData Caching Layer]
            // try? await localDataSource.saveProduct(product)
            
            return product
        } catch let error as APIError {
            throw APIErrorMapper.map(error)
        } catch {
            throw AppError.unknown(error.localizedDescription)
        }
    }
}
