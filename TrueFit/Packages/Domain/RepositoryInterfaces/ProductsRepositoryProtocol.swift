//
//  ProductsRepositoryProtocol.swift
//  TrueFit
//
//  Domain — Repository interface for products data.
//

import Foundation

protocol ProductsRepositoryProtocol {
    func fetchNewArrivals(limit: Int) async throws -> [Product]
    func fetchCollections() async throws -> [ProductCollection]
    func getProduct(id: String) async throws -> Product
    func fetchBrands() async throws -> [Brand]
    func fetchProductsByCollection(collectionId: Int64) async throws -> [Product]
    func fetchProductsByVendor(vendor: String) async throws -> [Product]
    func fetchAllProducts() async throws -> [Product]
}
