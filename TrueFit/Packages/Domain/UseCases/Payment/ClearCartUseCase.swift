import Foundation

struct ClearCartUseCase {
    private let repository: CartRepositoryProtocol
    
    init(repository: CartRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(cartId: String) async throws -> Cart {
        var cart = try await repository.getCart(id: cartId)
        
        for line in cart.lines {
            cart = try await repository.removeLine(cartId: cartId, lineId: line.id)
        }
        
        return cart
    }
}
