import Foundation

enum CurrencyRatesMapper {
    static func map(_ dto: CurrencyRatesResponseDTO) -> CurrencyRates {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let parsedDate = formatter.date(from: dto.date) ?? Date()
        
        var mappedRates: [String: Decimal] = [:]
        for (currencyCode, rateDouble) in dto.rates {
            // Safely convert Double to Decimal via String to prevent precision loss
            if let decimalRate = Decimal(string: String(rateDouble)) {
                mappedRates[currencyCode] = decimalRate
            }
        }
        
        return CurrencyRates(
            base: dto.base,
            date: parsedDate,
            rates: mappedRates
        )
    }
}
