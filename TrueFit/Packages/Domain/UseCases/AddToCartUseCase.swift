import Foundation

struct AddToCartUseCase {
    private let repository: CartRepositoryProtocol
    
    init(repository: CartRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(cartId: String?, variantId: String, quantity: Int) async throws -> Cart {
        if let cartId = cartId, !cartId.isEmpty {
            return try await repository.addToCart(cartId: cartId, variantId: variantId, quantity: quantity)
        } else {
            return try await repository.createCart(variantId: variantId, quantity: quantity)
        }
    }
}
