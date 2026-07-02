import Foundation

struct ProductMapper {
    static func map(_ dto: ShopifyProductDTO) -> Product {
        let id = String(dto.id ?? 0)
        let title = dto.title ?? ""
        let description = stripHTML(from: dto.body_html ?? "")
        let vendor = dto.vendor
        let productType = dto.product_type
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
        
        let mainImage = images.first { $0.position == 1 } ?? images.first
        
        let isAvailable = status == .active && variants.contains { variant in
            variant.inventoryQuantity ?? 0 > 0 || dto.variants?.first(where: { String($0.id ?? 0) == variant.id })?.inventory_policy == "continue"
        }
        
        let priceRange = computePriceRange(from: variants)
        let hasMultipleVariants = variants.count > 1
        
        let formatter = ISO8601DateFormatter()
        let createdAt = formatter.date(from: dto.created_at ?? "")
        let updatedAt = formatter.date(from: dto.updated_at ?? "")
        
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
    
    private static func mapVariant(_ dto: ShopifyProductVariantDTO, optionNames: [String]) -> ProductVariant? {
        guard let variantId = dto.id else { return nil }
        
        let price = Decimal(string: dto.price ?? "") ?? 0
        let compareAtPrice = Decimal(string: dto.compare_at_price ?? "")
        
        var selectedOptions: [String: String] = [:]
        let optionValues = [dto.option1, dto.option2, dto.option3].compactMap { $0 }
        
        for (index, value) in optionValues.enumerated() {
            if index < optionNames.count {
                selectedOptions[optionNames[index]] = value
            }
        }
        
        // According to requirement: isAvailable is true if inventory_quantity > 0 OR inventory_policy == "continue"
        let isAvailable = (dto.inventory_quantity ?? 0) > 0 || dto.inventory_policy == "continue"
        
        let imageId = dto.image_id.map { String($0) }
        
        return ProductVariant(
            id: String(variantId),
            title: dto.title ?? "",
            price: price,
            compareAtPrice: compareAtPrice,
            sku: dto.sku,
            isAvailable: isAvailable,
            requiresShipping: dto.requires_shipping ?? false,
            weight: dto.weight,
            weightUnit: dto.weight_unit,
            inventoryQuantity: dto.inventory_quantity,
            imageId: imageId,
            selectedOptions: selectedOptions
        )
    }
    
    private static func mapImage(_ dto: ShopifyProductImageDTO) -> ProductImage? {
        guard let id = dto.id, let srcString = dto.src, let src = URL(string: srcString) else { return nil }
        
        let variantIds = (dto.variant_ids ?? []).map { String($0) }
        
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
    
    private static func mapOption(_ dto: ShopifyProductOptionDTO) -> ProductOption? {
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
}
