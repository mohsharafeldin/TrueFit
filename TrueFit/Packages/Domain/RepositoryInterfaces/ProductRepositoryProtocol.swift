import Foundation

protocol ProductRepositoryProtocol {
    func getProduct(id: String) async throws -> Product
}
