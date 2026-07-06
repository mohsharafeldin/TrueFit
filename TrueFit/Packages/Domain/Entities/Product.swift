//
//  Product.swift
//  TrueFit
//
//  Domain Entity — Pure business model, no framework dependencies.
//

import Foundation

struct Product: Identifiable, Equatable {
    let id: String
    let title: String
    let description: String
    let vendor: String?
    let productType: String?
    let handle: String
    let status: ProductStatus
    let tags: [String]
    let variants: [ProductVariant]
    let images: [ProductImage]
    let options: [ProductOption]
    let mainImage: ProductImage?
    let isAvailable: Bool
    let priceRange: PriceRange
    let hasMultipleVariants: Bool
    let createdAt: Date?
    let updatedAt: Date?
    
    // Compatibility properties for develop branch features (HomeView)
    var price: String {
        "\(priceRange.min)"
    }
    var compareAtPrice: String? {
        variants.first?.compareAtPrice.map { "\($0)" }
    }
    var imageURL: URL? {
        mainImage?.src ?? images.first?.src
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
}

struct ProductVariant: Equatable {
    let id: String
    let title: String
    let price: Decimal
    let compareAtPrice: Decimal?
    let sku: String?
    let isAvailable: Bool
    let requiresShipping: Bool
    let weight: Double?
    let weightUnit: String?
    let inventoryQuantity: Int?
    let imageId: String?
    let selectedOptions: [String: String]
}

struct ProductImage: Equatable {
    let id: String
    let src: URL
    let altText: String?
    let width: Int?
    let height: Int?
    let position: Int
    let variantIds: [String]
}

struct ProductOption: Equatable {
    let id: String
    let name: String
    let values: [String]
}

struct PriceRange: Equatable {
    let min: Decimal
    let max: Decimal
    let isSinglePrice: Bool
}

enum ProductStatus: String, Equatable {
    case active
    case archived
    case draft
    case unknown
    
    init(rawValue: String) {
        switch rawValue.lowercased() {
        case "active": self = .active
        case "archived": self = .archived
        case "draft": self = .draft
        default: self = .unknown
        }
    }
}

extension Product {
    func toFavoriteItem() -> FavoriteItem {
        FavoriteItem(
            id: id,
            title: title,
            price: priceRange.min,
            vendor: vendor,
            imageURL: imageURL,
            addedAt: Date()
        )
    }
}
