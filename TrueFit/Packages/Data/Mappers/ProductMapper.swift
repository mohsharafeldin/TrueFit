//
//  ProductMapper.swift
//  TrueFit
//
//  Data — Maps ProductDTO → Product (domain entity).
//

import Foundation

enum ProductMapper {

    static func map(_ dto: ProductDTO) -> Product {
        let imageURL: URL? = {
            if let src = dto.image?.src ?? dto.images?.first?.src {
                return URL(string: src)
            }
            return nil
        }()

        let price = dto.variants?.first?.price ?? "0.00"
        let compareAtPrice = dto.variants?.first?.compareAtPrice

        let createdAt: Date? = {
            guard let dateString = dto.createdAt else { return nil }
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = formatter.date(from: dateString) { return date }
            // Fallback without fractional seconds
            formatter.formatOptions = [.withInternetDateTime]
            return formatter.date(from: dateString)
        }()

        return Product(
            id: dto.id,
            title: dto.title,
            vendor: dto.vendor,
            price: price,
            compareAtPrice: compareAtPrice,
            imageURL: imageURL,
            productType: dto.productType,
            createdAt: createdAt
        )
    }

    static func map(_ dtos: [ProductDTO]) -> [Product] {
        dtos.map { map($0) }
    }
}
