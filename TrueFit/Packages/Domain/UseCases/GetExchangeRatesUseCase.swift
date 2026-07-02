import Foundation

final class GetExchangeRatesUseCase {
    private let repository: CurrencyRepositoryProtocol
    
    init(repository: CurrencyRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(base: String = "USD") async throws -> CurrencyRates {
        // Future extension point: filtering to a subset of supported currencies 
        // (e.g. only show EGP, EUR, GBP, USD)
        // Future extension point: injecting a supported currencies list from remote config or local config
        return try await repository.getLatestRates(base: base)
    }
}
