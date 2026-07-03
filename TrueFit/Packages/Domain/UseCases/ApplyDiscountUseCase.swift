import Foundation

struct ApplyDiscountUseCase {
    private let repository: CartRepositoryProtocol
    
    init(repository: CartRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(cartId: String, code: String) async throws -> Cart {
        let formattedCode = code.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        return try await repository.applyDiscount(cartId: cartId, code: formattedCode)
    }
}
