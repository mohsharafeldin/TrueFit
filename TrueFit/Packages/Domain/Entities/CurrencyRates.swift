import Foundation

struct CurrencyRates {
    let base: String
    let date: Date
    let rates: [String: Decimal]
    
    // Convenience: look up a specific rate
    func rate(for currencyCode: String) -> Decimal? {
        // If the target is the base currency itself, the rate is 1.0
        if currencyCode == base { return 1.0 }
        return rates[currencyCode]
    }
    
    // Convert an amount from base currency to target
    func convert(_ amount: Decimal, to currencyCode: String) -> Decimal? {
        guard let exchangeRate = rate(for: currencyCode) else { return nil }
        return amount * exchangeRate
    }
}
