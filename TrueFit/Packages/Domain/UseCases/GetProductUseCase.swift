import Foundation

final class GetProductUseCase {
    private let repository: ProductRepositoryProtocol
    
    init(repository: ProductRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(productId: String) async throws -> Product {
        let product = try await repository.getProduct(id: productId)
        
        // [Future Business Logic Extension Points]
        // 1. Filtering unavailable variants:
        // let availableVariants = product.variants.filter { $0.isAvailable }
        // 
        // 2. Applying business pricing rules (e.g. VIP discount):
        // 
        // 3. Logging/Analytics hooks:
        // Analytics.logEvent("product_viewed", parameters: ["id": product.id])
        
        return product
    }
}
