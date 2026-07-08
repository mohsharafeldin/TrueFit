//
//  ProductsRepository.swift
//  TrueFit
//
//  Data — Implements ProductsRepositoryProtocol, coordinates data sources and mappers.
//

import Foundation

final class ProductsRepository: ProductsRepositoryProtocol {

    private let remoteDataSource: ProductsRemoteDataSourceProtocol
    private var cachedAllProducts: [Product]?
    private var lastFetchTime: Date?
    private let cacheLock = NSLock()

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

    // MARK: - Fetch Brands

    func fetchBrands() async throws -> [Brand] {
        // Fetch all active products and extract unique vendors
        let dtos = try await remoteDataSource.fetchProducts(limit: 250, sortKey: nil)
        
        // Group products by vendor to get counts and a representative image
        var vendorInfo: [String: (count: Int, imageURL: URL?)] = [:]
        
        // Use Google's favicon API which reliably returns high-res logos for these domains
        let knownLogos: [String: String] = [
            "ADIDAS": "https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=http://adidas.com&size=256",
            "ASICS": "https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=http://asics.com&size=256",
            "CONVERSE": "https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=http://converse.com&size=256",
            "DR MARTENS": "https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=http://drmartens.com&size=256",
            "NIKE": "https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=http://nike.com&size=256",
            "PUMA": "https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=http://puma.com&size=256",
            "VANS": "https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=http://vans.com&size=256",
            "TIMBERLAND": "https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=http://timberland.com&size=256",
            "SUPRA": "https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=http://suprafootwear.com&size=256",
            "PALLADIUM": "https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=http://palladiumboots.com&size=256"
        ]
        
        for dto in dtos {
            guard let vendor = dto.vendor, !vendor.isEmpty else { continue }
            let existing = vendorInfo[vendor]
            let currentCount = (existing?.count ?? 0) + 1
            
            // Try to match the vendor name with known logos
            let upperVendor = vendor.uppercased()
            let imageURL: URL? = {
                // First check our known logos dictionary
                if let logoString = knownLogos.first(where: { upperVendor.contains($0.key) })?.value {
                    return URL(string: logoString)
                }
                // Fallback: don't use product image, just use nil so it shows the brand initials
                return nil
            }()
            
            vendorInfo[vendor] = (count: currentCount, imageURL: imageURL)
        }
        
        return vendorInfo.map { vendor, info in
            Brand(
                id: vendor,
                name: vendor,
                productCount: info.count,
                imageURL: info.imageURL
            )
        }
        .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    // MARK: - Fetch Products by Collection

    func fetchProductsByCollection(collectionId: Int64) async throws -> [Product] {
        do {
            let dtos = try await remoteDataSource.fetchProductsByCollection(collectionId: collectionId)
            return ProductMapper.map(dtos)
        } catch let error as APIError {
            throw APIErrorMapper.map(error)
        } catch {
            throw AppError.unknown(error.localizedDescription)
        }
    }

    // MARK: - Fetch Products by Vendor

    func fetchProductsByVendor(vendor: String) async throws -> [Product] {
        do {
            let dtos = try await remoteDataSource.fetchProductsByVendor(vendor: vendor)
            return ProductMapper.map(dtos)
        } catch let error as APIError {
            throw APIErrorMapper.map(error)
        } catch {
            throw AppError.unknown(error.localizedDescription)
        }
    }

    // MARK: - Fetch All Products

    func fetchAllProducts() async throws -> [Product] {
        if let cached = cacheLock.withLock({
            if let cached = cachedAllProducts, let lastTime = lastFetchTime, Date().timeIntervalSince(lastTime) < 300 {
                return cached
            }
            return nil as [Product]?
        }) {
            return cached
        }
        
        do {
            let dtos = try await remoteDataSource.fetchAllProducts()
            let products = ProductMapper.map(dtos)
            
            cacheLock.withLock {
                cachedAllProducts = products
                lastFetchTime = Date()
            }
            
            return products
        } catch let error as APIError {
            throw APIErrorMapper.map(error)
        } catch {
            throw AppError.unknown(error.localizedDescription)
        }
    }
}
