import Foundation

protocol GenericEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}
