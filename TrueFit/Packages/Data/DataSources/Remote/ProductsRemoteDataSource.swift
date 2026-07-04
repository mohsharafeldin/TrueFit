//
//  ProductsRemoteDataSource.swift
//  TrueFit
//
//  Data — Remote data source for Shopify API calls.
//

import Foundation
import Alamofire

// MARK: - Protocol

protocol ProductsRemoteDataSourceProtocol {
    func fetchProducts(limit: Int, sortKey: String?) async throws -> [ProductDTO]
    func fetchSmartCollections() async throws -> [CollectionDTO]
    func fetchCustomCollections() async throws -> [CollectionDTO]
    func fetchProductsCount(collectionId: Int64) async throws -> Int
    func fetchProduct(id: String) async throws -> ProductDTO
    func fetchProductsByCollection(collectionId: Int64) async throws -> [ProductDTO]
    func fetchProductsByVendor(vendor: String) async throws -> [ProductDTO]
}

// MARK: - Implementation

final class ProductsRemoteDataSource: ProductsRemoteDataSourceProtocol {
    

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchProducts(limit: Int, sortKey: String?) async throws -> [ProductDTO] {
        let endpoint = ProductsEndpoint.products(limit: limit, sortKey: sortKey)
        let response: ProductsResponseDTO = try await apiClient.request(endpoint)
        return response.products
    }

    func fetchSmartCollections() async throws -> [CollectionDTO] {
        let endpoint = ProductsEndpoint.smartCollections
        let response: SmartCollectionsResponseDTO = try await apiClient.request(endpoint)
        return response.smartCollections
    }

    func fetchCustomCollections() async throws -> [CollectionDTO] {
        let endpoint = ProductsEndpoint.customCollections
        let response: CustomCollectionsResponseDTO = try await apiClient.request(endpoint)
        return response.customCollections
    }

    func fetchProductsCount(collectionId: Int64) async throws -> Int {
        let endpoint = ProductsEndpoint.productsCount(collectionId: collectionId)
        let response: ProductsCountResponseDTO = try await apiClient.request(endpoint)
        return response.count
    }
    
    
    func fetchProduct(id: String) async throws -> ProductDTO {
        let endpoint = GetProductEndpoint(productId: id)
        let response: ProductResponseDTO = try await apiClient.request(endpoint)
        
        guard let product = response.product else {
            throw APIError.decodingFailed(NSError(domain: "ProductRemoteDataSource", code: 0, userInfo: [NSLocalizedDescriptionKey: "Product data is missing in the response"]))
        }
        
        return product
    }

    func fetchProductsByCollection(collectionId: Int64) async throws -> [ProductDTO] {
        let endpoint = ProductsEndpoint.productsByCollection(collectionId: collectionId)
        let response: ProductsResponseDTO = try await apiClient.request(endpoint)
        return response.products
    }

    func fetchProductsByVendor(vendor: String) async throws -> [ProductDTO] {
        let endpoint = ProductsEndpoint.productsByVendor(vendor: vendor)
        let response: ProductsResponseDTO = try await apiClient.request(endpoint)
        return response.products
    }
}

// MARK: - Endpoints

enum ProductsEndpoint: Endpoint {

    case products(limit: Int, sortKey: String?)
    case smartCollections
    case customCollections
    case productsCount(collectionId: Int64)
    case productsByCollection(collectionId: Int64)
    case productsByVendor(vendor: String)

    var path: String {
        switch self {
        case .products, .productsByCollection, .productsByVendor:
            return "/products.json"
        case .smartCollections:
            return "/smart_collections.json"
        case .customCollections:
            return "/custom_collections.json"
        case .productsCount:
            return "/products/count.json"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .products(let limit, let sortKey):
            var items: [URLQueryItem] = [
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "status", value: "active")
            ]
            if let sortKey {
                items.append(URLQueryItem(name: "sort_key", value: sortKey))
                items.append(URLQueryItem(name: "order", value: "desc"))
            }
            return items

        case .productsByCollection(let collectionId):
            return [
                URLQueryItem(name: "collection_id", value: "\(collectionId)"),
                URLQueryItem(name: "status", value: "active"),
                URLQueryItem(name: "limit", value: "50")
            ]

        case .productsByVendor(let vendor):
            return [
                URLQueryItem(name: "vendor", value: vendor),
                URLQueryItem(name: "status", value: "active"),
                URLQueryItem(name: "limit", value: "50")
            ]

        case .smartCollections, .customCollections:
            return nil

        case .productsCount(let collectionId):
            return [
                URLQueryItem(name: "collection_id", value: "\(collectionId)")
            ]
        }
    }

    var body: Encodable? {
        nil
    }
}
