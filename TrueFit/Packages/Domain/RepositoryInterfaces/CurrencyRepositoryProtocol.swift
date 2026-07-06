import Foundation

protocol CurrencyRepositoryProtocol {
    func getLatestRates(base: String) async throws -> CurrencyRates
}
