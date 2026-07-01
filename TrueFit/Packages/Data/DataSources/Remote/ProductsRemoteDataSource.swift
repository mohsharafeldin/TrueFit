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
}

// MARK: - Endpoints

enum ProductsEndpoint: Endpoint {

    case products(limit: Int, sortKey: String?)
    case smartCollections
    case customCollections
    case productsCount(collectionId: Int64)

    var path: String {
        switch self {
        case .products:
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
