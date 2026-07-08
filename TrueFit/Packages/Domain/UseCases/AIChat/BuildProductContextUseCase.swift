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
        // Fetch products from the store
        let allProducts = try await productsRepository.fetchAllProducts()
        
        // Filter active and available products
        let availableProducts = allProducts.filter { product in
            product.isAvailable && product.status == .active
        }
        
        // Limit to top 50 products to avoid hitting Gemini's Token Quota
        let limitedProducts = Array(availableProducts.prefix(50))
        
        // Build the AI Persona and Rules
        var context = """
        You are an expert personal stylist for the 'TrueFit' iOS app.
        Your tone should be friendly, helpful, and concise.
        You must ONLY recommend products listed below. If a user asks for something else, say it's unavailable but suggest a close alternative from the list.
        Always state the product title and price.

        --- TRUEFIT PRODUCT CATALOG ---
        
        """
        
        // Compress the product list into a highly token-efficient string
        for product in limitedProducts {
            // Very short format: Title ($Price)
            let productInfo = "- \(product.title) ($\(product.price))"
            context.append(productInfo + "\n")
        }
        
        return context
    }
}
