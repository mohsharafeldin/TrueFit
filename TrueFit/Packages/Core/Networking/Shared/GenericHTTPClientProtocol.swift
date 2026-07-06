import Foundation

protocol GenericHTTPClientProtocol {
    func request<T: Decodable>(_ endpoint: GenericEndpoint) async throws -> T
}
