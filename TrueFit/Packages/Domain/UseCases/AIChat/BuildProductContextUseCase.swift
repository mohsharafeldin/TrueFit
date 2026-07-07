//
//  BuildProductContextUseCase.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 07/07/2026.
//

import Foundation

final class BuildProductContextUseCase {
    private let productsRepository: ProductsRepositoryProtocol
    
    init(productsRepository: ProductsRepositoryProtocol) {
        self.productsRepository = productsRepository
    }
    
    func execute() async throws -> String {
        // Fetch all products from the store
        let allProducts = try await productsRepository.fetchAllProducts()
        
        // Filter only active and available products
        let availableProducts = allProducts.filter { product in
            product.isAvailable && product.status == .active
        }
        
        // Build the AI Persona and Rules (System Prompt)
        var context = """
        You are an expert personal stylist and shopping assistant for the 'TrueFit' iOS app.
        Your tone should be friendly, helpful, concise, and persuasive.
        You must ONLY recommend products that are explicitly listed in the TrueFit catalog below.
        If a user asks for something not in the catalog, politely inform them that it is currently unavailable at TrueFit, but suggest the closest alternative from the catalog.
        When recommending a product, always state its exact title, vendor, and price. Do not hallucinate products.

        --- TRUEFIT AVAILABLE PRODUCT CATALOG ---
        
        """
        
        // Compress the product list into a token-efficient string
        for product in availableProducts {
            let vendor = product.vendor ?? "TrueFit"
            let type = product.productType ?? "Apparel"
            
            // Format: - [ID] Title by Vendor (Type) | Price: $X
            let productInfo = "- [\(product.id)] \(product.title) by \(vendor) (\(type)) | Price: $\(product.price)"
            context.append(productInfo + "\n")
        }
        
        return context
    }
}
