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

struct ProductResponseDTO: Decodable {
    let product: ProductDTO?
}

// MARK: - Product DTO

struct ProductDTO: Decodable {
    let id: Int64
    let title: String
    let vendor: String?
    let productType: String?
    let createdAt: String?
    let updatedAt: String?
    let publishedAt: String?
    let bodyHtml: String?
    let handle: String?
    let status: String?
    let tags: String?
    let templateSuffix: String?
    let publishedScope: String?
    let adminGraphqlApiId: String?
    
    let images: [ProductImageDTO]?
    let variants: [ProductVariantDTO]?
    let options: [ProductOptionDTO]?
    let image: ProductImageDTO?

    enum CodingKeys: String, CodingKey {
        case id, title, vendor, status, tags, image, images, variants, options, handle
        case productType = "product_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case bodyHtml = "body_html"
        case templateSuffix = "template_suffix"
        case publishedScope = "published_scope"
        case adminGraphqlApiId = "admin_graphql_api_id"
    }
}

// MARK: - Nested DTOs

struct ProductImageDTO: Decodable {
    let id: Int64?
    let src: String
    let width: Int?
    let height: Int?
    let position: Int?
    let alt: String?
    let createdAt: String?
    let updatedAt: String?
    let variantIds: [Int64]?
    
    enum CodingKeys: String, CodingKey {
        case id, src, width, height, position, alt
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case variantIds = "variant_ids"
    }
}

struct ProductVariantDTO: Decodable {
    let id: Int64
    let price: String
    let compareAtPrice: String?
    let title: String?
    let sku: String?
    let position: Int?
    let inventoryPolicy: String?
    let fulfillmentService: String?
    let inventoryManagement: String?
    let option1: String?
    let option2: String?
    let option3: String?
    let createdAt: String?
    let updatedAt: String?
    let taxable: Bool?
    let barcode: String?
    let grams: Int?
    let weight: Double?
    let weightUnit: String?
    let inventoryItemId: Int64?
    let inventoryQuantity: Int?
    let oldInventoryQuantity: Int?
    let requiresShipping: Bool?
    let imageId: Int64?

    enum CodingKeys: String, CodingKey {
        case id, price, title, sku, position, option1, option2, option3, taxable, barcode, grams, weight
        case compareAtPrice = "compare_at_price"
        case inventoryPolicy = "inventory_policy"
        case fulfillmentService = "fulfillment_service"
        case inventoryManagement = "inventory_management"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case weightUnit = "weight_unit"
        case inventoryItemId = "inventory_item_id"
        case inventoryQuantity = "inventory_quantity"
        case oldInventoryQuantity = "old_inventory_quantity"
        case requiresShipping = "requires_shipping"
        case imageId = "image_id"
    }
}

struct ProductOptionDTO: Decodable {
    let id: Int64?
    let productId: Int64?
    let name: String?
    let position: Int?
    let values: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, position, values
        case productId = "product_id"
    }
}
