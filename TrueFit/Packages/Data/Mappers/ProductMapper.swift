import Foundation

enum ProductMapper {
    static func map(_ dto: ProductDTO) -> Product {
        let id = String(dto.id)
        let title = dto.title
        let description = stripHTML(from: dto.bodyHtml ?? "")
        let vendor = dto.vendor
        let productType = dto.productType
        let handle = dto.handle ?? ""
        let status = ProductStatus(rawValue: dto.status ?? "unknown")
        
        let tags: [String] = {
            guard let tagsString = dto.tags, !tagsString.isEmpty else { return [] }
            return tagsString.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        }()
        
        let options = (dto.options ?? []).compactMap { mapOption($0) }
        let optionNames = options.map { $0.name }
        
        let variants = (dto.variants ?? []).compactMap { mapVariant($0, optionNames: optionNames) }
        let images = (dto.images ?? []).compactMap { mapImage($0) }
        
        // Handle main image properly. If no images array but there is a single `image`, parse it.
        var mainImage = images.first { $0.position == 1 } ?? images.first
        if mainImage == nil, let singleImage = dto.image {
            mainImage = mapImage(singleImage)
        }
        
        let isAvailable = status == .active && variants.contains { variant in
            variant.inventoryQuantity ?? 0 > 0 || dto.variants?.first(where: { String($0.id) == variant.id })?.inventoryPolicy == "continue"
        }
        
        let priceRange = computePriceRange(from: variants)
        let hasMultipleVariants = variants.count > 1
        
        let createdAt: Date? = {
            guard let dateString = dto.createdAt else { return nil }
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = formatter.date(from: dateString) { return date }
            formatter.formatOptions = [.withInternetDateTime]
            return formatter.date(from: dateString)
        }()
        
        let updatedAt: Date? = {
            guard let dateString = dto.updatedAt else { return nil }
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = formatter.date(from: dateString) { return date }
            formatter.formatOptions = [.withInternetDateTime]
            return formatter.date(from: dateString)
        }()
        
        return Product(
            id: id,
            title: title,
            description: description,
            vendor: vendor,
            productType: productType,
            handle: handle,
            status: status,
            tags: tags,
            variants: variants,
            images: images,
            options: options,
            mainImage: mainImage,
            isAvailable: isAvailable,
            priceRange: priceRange,
            hasMultipleVariants: hasMultipleVariants,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
    
    private static func mapVariant(_ dto: ProductVariantDTO, optionNames: [String]) -> ProductVariant? {
        let price = Decimal(string: dto.price) ?? 0
        let compareAtPrice = Decimal(string: dto.compareAtPrice ?? "")
        
        var selectedOptions: [String: String] = [:]
        let optionValues = [dto.option1, dto.option2, dto.option3].compactMap { $0 }
        
        for (index, value) in optionValues.enumerated() {
            if index < optionNames.count {
                selectedOptions[optionNames[index]] = value
            }
        }
        
        let isAvailable = (dto.inventoryQuantity ?? 0) > 0 || dto.inventoryPolicy == "continue"
        
        let imageId = dto.imageId.map { String($0) }
        
        return ProductVariant(
            id: String(dto.id),
            title: dto.title ?? "",
            price: price,
            compareAtPrice: compareAtPrice,
            sku: dto.sku,
            isAvailable: isAvailable,
            requiresShipping: dto.requiresShipping ?? false,
            weight: dto.weight,
            weightUnit: dto.weightUnit,
            inventoryQuantity: dto.inventoryQuantity,
            imageId: imageId,
            selectedOptions: selectedOptions
        )
    }
    
    private static func mapImage(_ dto: ProductImageDTO) -> ProductImage? {
        guard let id = dto.id, let src = URL(string: dto.src) else { return nil }
        
        let variantIds = (dto.variantIds ?? []).map { String($0) }
        
        return ProductImage(
            id: String(id),
            src: src,
            altText: dto.alt,
            width: dto.width,
            height: dto.height,
            position: dto.position ?? 0,
            variantIds: variantIds
        )
    }
    
    private static func mapOption(_ dto: ProductOptionDTO) -> ProductOption? {
        guard let id = dto.id, let name = dto.name else { return nil }
        return ProductOption(
            id: String(id),
            name: name,
            values: dto.values ?? []
        )
    }
    
    private static func computePriceRange(from variants: [ProductVariant]) -> PriceRange {
        guard let firstVariant = variants.first else {
            return PriceRange(min: 0, max: 0, isSinglePrice: true)
        }
        
        var minPrice = firstVariant.price
        var maxPrice = firstVariant.price
        
        for variant in variants {
            if variant.price < minPrice { minPrice = variant.price }
            if variant.price > maxPrice { maxPrice = variant.price }
        }
        
        return PriceRange(min: minPrice, max: maxPrice, isSinglePrice: minPrice == maxPrice)
    }
    
    private static func stripHTML(from string: String) -> String {
        return string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }

    static func map(_ dtos: [ProductDTO]) -> [Product] {
        dtos.map { map($0) }
    }
}
