import Foundation

protocol CartRepositoryProtocol {
    func getCart(id: String) async throws -> Cart
    func createCart(variantId: String, quantity: Int) async throws -> Cart
    func addToCart(cartId: String, variantId: String, quantity: Int) async throws -> Cart
    func updateQuantity(cartId: String, lineId: String, quantity: Int) async throws -> Cart
    func removeLine(cartId: String, lineId: String) async throws -> Cart
    func applyDiscount(cartId: String, code: String) async throws -> Cart
}
