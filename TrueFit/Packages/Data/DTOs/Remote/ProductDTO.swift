//
//  ProductDTO.swift
//  TrueFit
//
//  Data — Decodable DTO matching Shopify Admin REST API product response.
//

import Foundation

// MARK: - Top-level response wrapper

struct ProductsResponseDTO: Decodable {
    let products: [ProductDTO]
}

// MARK: - Product DTO

struct ProductDTO: Decodable {
    let id: Int64
    let title: String
    let vendor: String
    let productType: String
    let createdAt: String?
    let images: [ProductImageDTO]?
    let variants: [ProductVariantDTO]?
    let image: ProductImageDTO?
    let status: String?
    let tags: String?

    enum CodingKeys: String, CodingKey {
        case id, title, vendor, status, tags, image, images, variants
        case productType = "product_type"
        case createdAt = "created_at"
    }
}

// MARK: - Nested DTOs

struct ProductImageDTO: Decodable {
    let id: Int64?
    let src: String
    let width: Int?
    let height: Int?
}

struct ProductVariantDTO: Decodable {
    let id: Int64
    let price: String
    let compareAtPrice: String?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case id, price, title
        case compareAtPrice = "compare_at_price"
    }
}
