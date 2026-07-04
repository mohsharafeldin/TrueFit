import Foundation

struct RemoveCartLineUseCase {
    private let repository: CartRepositoryProtocol
    
    init(repository: CartRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(cartId: String, lineId: String) async throws -> Cart {
        return try await repository.removeLine(cartId: cartId, lineId: lineId)
    }
}
