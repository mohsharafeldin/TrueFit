import Foundation

struct CurrencyRatesResponseDTO: Decodable {
    let amount: Double
    let base: String
    let date: String
    let rates: [String: Double]
}
