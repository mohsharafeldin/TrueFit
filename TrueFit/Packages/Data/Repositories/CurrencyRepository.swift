import Foundation

final class CurrencyRepository: CurrencyRepositoryProtocol {
    private let remoteDataSource: CurrencyRemoteDataSourceProtocol
    
    // Placeholder for caching implementation:
    // e.g. private var cache: CurrencyRates?
    // private var lastFetchDate: Date?
    // TTL = 3600 seconds
    
    init(remoteDataSource: CurrencyRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getLatestRates(base: String) async throws -> CurrencyRates {
        // Here we could check cache and return if valid
        // if let cache = cache, let lastFetch = lastFetchDate, Date().timeIntervalSince(lastFetch) < 3600 {
        //     return cache
        // }
        
        do {
            let dto = try await remoteDataSource.fetchLatestRates(from: base)
            let entity = CurrencyRatesMapper.map(dto)
            
            // Update cache here
            // self.cache = entity
            // self.lastFetchDate = Date()
            
            return entity
        } catch let error as GenericAPIError {
            throw GenericAPIErrorMapper.map(error)
        } catch {
            throw AppError.unknown(error.localizedDescription)
        }
    }
}
