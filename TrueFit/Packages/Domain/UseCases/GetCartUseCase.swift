import Foundation

struct GetCartUseCase {
    private let repository: CartRepositoryProtocol
    
    init(repository: CartRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(cartId: String) async throws -> Cart {
        return try await repository.getCart(id: cartId)
    }
}
