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

    // MARK: - Compatibility with HomeView/Develop branch
    static func map(_ dto: ProductDTO) -> Product {
        let imageURL: URL? = {
            if let src = dto.image?.src ?? dto.images?.first?.src {
                return URL(string: src)
            }
            return nil
        }()

        let priceDecimal = Decimal(string: dto.variants?.first?.price ?? "0.00") ?? 0
        let compareAtPriceDecimal = Decimal(string: dto.variants?.first?.compareAtPrice ?? "")
        
        let createdAt: Date? = {
            guard let dateString = dto.createdAt else { return nil }
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = formatter.date(from: dateString) { return date }
            // Fallback without fractional seconds
            formatter.formatOptions = [.withInternetDateTime]
            return formatter.date(from: dateString)
        }()

        let mainImage = imageURL.map { ProductImage(id: "", src: $0, altText: nil, width: nil, height: nil, position: 1, variantIds: []) }
        let variant = ProductVariant(id: "", title: "", price: priceDecimal, compareAtPrice: compareAtPriceDecimal, sku: nil, isAvailable: true, requiresShipping: false, weight: nil, weightUnit: nil, inventoryQuantity: nil, imageId: nil, selectedOptions: [:])

        return Product(
            id: String(dto.id),
            title: dto.title,
            description: "",
            vendor: dto.vendor,
            productType: dto.productType,
            handle: "",
            status: .active,
            tags: [],
            variants: [variant],
            images: mainImage != nil ? [mainImage!] : [],
            options: [],
            mainImage: mainImage,
            isAvailable: true,
            priceRange: PriceRange(min: priceDecimal, max: priceDecimal, isSinglePrice: true),
            hasMultipleVariants: false,
            createdAt: createdAt,
            updatedAt: nil
        )
    }

    static func map(_ dtos: [ProductDTO]) -> [Product] {
        dtos.map { map($0) }
    }
}
