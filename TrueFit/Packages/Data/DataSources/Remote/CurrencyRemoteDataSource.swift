import Foundation

protocol CurrencyRemoteDataSourceProtocol {
    func fetchLatestRates(from base: String) async throws -> CurrencyRatesResponseDTO
}

final class CurrencyRemoteDataSource: CurrencyRemoteDataSourceProtocol {
    private let apiClient: GenericHTTPClientProtocol
    
    init(apiClient: GenericHTTPClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchLatestRates(from base: String) async throws -> CurrencyRatesResponseDTO {
        let endpoint = GetLatestRatesEndpoint(baseCurrency: base)
        return try await apiClient.request(endpoint)
    }
}
