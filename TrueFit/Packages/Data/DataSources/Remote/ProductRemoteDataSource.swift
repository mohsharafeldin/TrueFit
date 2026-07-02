import Foundation

protocol ProductRemoteDataSourceProtocol {
    func fetchProduct(id: String) async throws -> ShopifyProductDTO
}

final class ProductRemoteDataSource: ProductRemoteDataSourceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchProduct(id: String) async throws -> ShopifyProductDTO {
        let endpoint = GetProductEndpoint(productId: id)
        let response: ShopifyProductResponseDTO = try await apiClient.request(endpoint)
        
        guard let product = response.product else {
            throw APIError.decodingFailed(NSError(domain: "ProductRemoteDataSource", code: 0, userInfo: [NSLocalizedDescriptionKey: "Product data is missing in the response"]))
        }
        
        return product
    }
}
