import Foundation
import Combine

final class CurrencyManager: ObservableObject {
    static let shared = CurrencyManager()
    
    @Published var selectedCurrency: String {
        didSet {
            UserDefaults.standard.set(selectedCurrency, forKey: "selectedCurrency")
        }
    }
    
    @Published var rates: [String: Decimal] = [:] {
        didSet {
            if let data = try? JSONEncoder().encode(rates) {
                UserDefaults.standard.set(data, forKey: "currencyRates")
            }
        }
    }
    
    private init() {
        self.selectedCurrency = UserDefaults.standard.string(forKey: "selectedCurrency") ?? "EGP"
        if let data = UserDefaults.standard.data(forKey: "currencyRates"),
           let savedRates = try? JSONDecoder().decode([String: Decimal].self, from: data) {
            self.rates = savedRates
        }
    }
    
    func convert(_ price: Decimal) -> Decimal {
        let rate = rates[selectedCurrency] ?? 1.0
        return price * rate
    }
}
