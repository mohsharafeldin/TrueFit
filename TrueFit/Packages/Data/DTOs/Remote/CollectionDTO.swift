//
//  CollectionDTO.swift
//  TrueFit
//
//  Data — Decodable DTOs matching Shopify Admin REST API collection responses.
//

import Foundation

// MARK: - Smart Collections Response

struct SmartCollectionsResponseDTO: Decodable {
    let smartCollections: [CollectionDTO]

    enum CodingKeys: String, CodingKey {
        case smartCollections = "smart_collections"
    }
}

// MARK: - Custom Collections Response

struct CustomCollectionsResponseDTO: Decodable {
    let customCollections: [CollectionDTO]

    enum CodingKeys: String, CodingKey {
        case customCollections = "custom_collections"
    }
}

// MARK: - Collection DTO (shared between smart & custom)

struct CollectionDTO: Decodable {
    let id: Int64
    let title: String
    let image: CollectionImageDTO?
    let productsCount: Int?
    let bodyHtml: String?

    enum CodingKeys: String, CodingKey {
        case id, title, image
        case productsCount = "products_count"
        case bodyHtml = "body_html"
    }
}

struct CollectionImageDTO: Decodable {
    let src: String
    let width: Int?
    let height: Int?
}

// MARK: - Products Count Response

struct ProductsCountResponseDTO: Decodable {
    let count: Int
}
