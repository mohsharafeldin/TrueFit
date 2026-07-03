import Foundation

struct UpdateCartLineUseCase {
    private let repository: CartRepositoryProtocol
    
    init(repository: CartRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(cartId: String, lineId: String, quantity: Int) async throws -> Cart {
        if quantity <= 0 {
            return try await repository.removeLine(cartId: cartId, lineId: lineId)
        } else {
            return try await repository.updateQuantity(cartId: cartId, lineId: lineId, quantity: quantity)
        }
    }
}
