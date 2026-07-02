import Foundation

struct Product {
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
}

struct ProductVariant {
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

struct ProductImage {
    let id: String
    let src: URL
    let altText: String?
    let width: Int?
    let height: Int?
    let position: Int
    let variantIds: [String]
}

struct ProductOption {
    let id: String
    let name: String
    let values: [String]
}

struct PriceRange {
    let min: Decimal
    let max: Decimal
    let isSinglePrice: Bool
}

enum ProductStatus: String {
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
