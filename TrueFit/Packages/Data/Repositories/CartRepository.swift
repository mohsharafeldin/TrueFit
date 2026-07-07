import Foundation

final class CartRepository: CartRepositoryProtocol {
    private let remoteDataSource: CartRemoteDataSourceProtocol
    private let productsRepository: ProductsRepositoryProtocol?
    
    init(remoteDataSource: CartRemoteDataSourceProtocol, productsRepository: ProductsRepositoryProtocol? = nil) {
        self.remoteDataSource = remoteDataSource
        self.productsRepository = productsRepository
    }
    
    // MARK: - CartRepositoryProtocol
    
    func getCart(id: String) async throws -> Cart {
        do {
            let cart = try await remoteDataSource.fetchCart(id: id)
            return await enrichCart(cart)
        } catch let error as APIError {
            throw APIErrorMapper.map(error)
        } catch {
            throw AppError.unknown(error.localizedDescription)
        }
    }
    
    func createCart(variantId: String, quantity: Int) async throws -> Cart {
        do {
            let cart = try await remoteDataSource.createCart(variantId: variantId, quantity: quantity)
            return await enrichCart(cart)
        } catch let error as APIError {
            throw APIErrorMapper.map(error)
        } catch {
            throw AppError.unknown(error.localizedDescription)
        }
    }
    
    func addToCart(cartId: String, variantId: String, quantity: Int) async throws -> Cart {
        do {
            let cart = try await remoteDataSource.addLines(cartId: cartId, variantId: variantId, quantity: quantity)
            return await enrichCart(cart)
        } catch let error as APIError {
            throw APIErrorMapper.map(error)
        } catch {
            throw AppError.unknown(error.localizedDescription)
        }
    }
    
    func updateQuantity(cartId: String, lineId: String, quantity: Int) async throws -> Cart {
        do {
            let cart = try await remoteDataSource.updateLine(cartId: cartId, lineId: lineId, quantity: quantity)
            return await enrichCart(cart)
        } catch let error as APIError {
            throw APIErrorMapper.map(error)
        } catch {
            throw AppError.unknown(error.localizedDescription)
        }
    }
    
    func removeLine(cartId: String, lineId: String) async throws -> Cart {
        do {
            let cart = try await remoteDataSource.removeLine(cartId: cartId, lineId: lineId)
            return await enrichCart(cart)
        } catch let error as APIError {
            throw APIErrorMapper.map(error)
        } catch {
            throw AppError.unknown(error.localizedDescription)
        }
    }
    
    func applyDiscount(cartId: String, code: String) async throws -> Cart {
        do {
            let cart = try await remoteDataSource.applyDiscount(cartId: cartId, code: code)
            return await enrichCart(cart)
        } catch let error as APIError {
            throw APIErrorMapper.map(error)
        } catch {
            throw AppError.unknown(error.localizedDescription)
        }
    }
    
    // MARK: - Enrichment Helper
    
    private func enrichCart(_ cart: Cart) async -> Cart {
        guard let productsRepository = productsRepository else { return cart }
        
        let needsEnrichment = cart.lines.contains { line in
            line.imageURL == nil || line.productTitle == "Product Item" || line.productTitle.isEmpty || line.variantTitle == "Product Item"
        }
        guard needsEnrichment else { return cart }
        
        guard let allProducts = try? await productsRepository.fetchAllProducts() else { return cart }
        
        var enrichedLines: [CartLine] = []
        for line in cart.lines {
            let cleanVariantId = line.variantId.components(separatedBy: "/").last ?? line.variantId
            let cleanProductId = line.productId.components(separatedBy: "/").last ?? line.productId
            
            var newTitle = line.productTitle
            var newImageURL = line.imageURL
            var newVariantTitle = line.variantTitle
            
            if let matchedProduct = allProducts.first(where: { product in
                product.id == cleanProductId || product.variants.contains(where: { $0.id == cleanVariantId || $0.id.hasSuffix(cleanVariantId) })
            }) {
                if newTitle == "Product Item" || newTitle.isEmpty {
                    newTitle = matchedProduct.title
                }
                if newImageURL == nil {
                    if let matchedVariant = matchedProduct.variants.first(where: { $0.id == cleanVariantId || $0.id.hasSuffix(cleanVariantId) }),
                       let imageId = matchedVariant.imageId,
                       let variantImage = matchedProduct.images.first(where: { $0.id == imageId }) {
                        newImageURL = variantImage.src
                    } else {
                        newImageURL = matchedProduct.mainImage?.src ?? matchedProduct.images.first?.src
                    }
                }
                if let matchedVariant = matchedProduct.variants.first(where: { $0.id == cleanVariantId || $0.id.hasSuffix(cleanVariantId) }),
                   newVariantTitle.isEmpty || newVariantTitle == "Default Title" || newVariantTitle == "Product Item" || newVariantTitle == newTitle {
                    newVariantTitle = matchedVariant.title
                }
            }
            
            let enrichedLine = CartLine(
                id: line.id,
                quantity: line.quantity,
                variantId: line.variantId,
                variantTitle: newVariantTitle,
                productId: line.productId,
                productTitle: newTitle,
                productHandle: line.productHandle,
                imageURL: newImageURL,
                imageAltText: line.imageAltText,
                unitPrice: line.unitPrice,
                compareAtPrice: line.compareAtPrice,
                lineTotal: line.lineTotal,
                compareAtLineTotal: line.compareAtLineTotal
            )
            enrichedLines.append(enrichedLine)
        }
        
        return Cart(
            id: cart.id,
            lines: enrichedLines,
            totalQuantity: cart.totalQuantity,
            subtotal: cart.subtotal,
            total: cart.total,
            totalTax: cart.totalTax,
            discountCodes: cart.discountCodes,
            checkoutURL: cart.checkoutURL
        )
    }
}
