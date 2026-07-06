import Foundation


@MainActor
final class CurrencyConverterViewModel: ObservableObject {
    private let getExchangeRatesUseCase: GetExchangeRatesUseCase
    
    @Published var state: ViewState<CurrencyRates> = .idle
    @Published var inputAmount: String = ""
    @Published var selectedCurrency: String = "EGP"
    @Published var availableCurrencies: [String] = []
    
    init(getExchangeRatesUseCase: GetExchangeRatesUseCase) {
        self.getExchangeRatesUseCase = getExchangeRatesUseCase
    }
    
    func loadRates() async {
        state = .loading
        do {
            let rates = try await getExchangeRatesUseCase.execute(base: "USD")
            
            var currencies = Array(rates.rates.keys)
            if !currencies.contains(rates.base) {
                currencies.append(rates.base)
            }
            
            self.availableCurrencies = currencies.sorted()
            
            if !self.availableCurrencies.contains(selectedCurrency), let first = self.availableCurrencies.first {
                selectedCurrency = first
            }
            
            state = .success(rates)
        } catch let appError as AppError {
            ErrorLogger.log(appError, context: "CurrencyConverterViewModel.loadRates")
            state = .failure(appError)
        } catch {
            let unknownError = AppError.unknown(error.localizedDescription)
            ErrorLogger.log(unknownError, context: "CurrencyConverterViewModel.loadRates")
            state = .failure(unknownError)
        }
    }
    
    func retry() async {
        await loadRates()
    }
    
    func selectCurrency(_ code: String) {
        selectedCurrency = code
    }
    
    var convertedAmount: String {
        guard case .success(let rates) = state else { return "" }
        guard let decimalAmount = Decimal(string: inputAmount), decimalAmount > 0 else { return "" }
        
        guard let result = rates.convert(decimalAmount, to: selectedCurrency) else { return "" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        if let formatted = formatter.string(from: result as NSDecimalNumber) {
            return "\(formatted) \(selectedCurrency)"
        }
        return ""
    }
    
    var rateDisplayText: String {
        guard case .success(let rates) = state else { return "" }
        guard let rate = rates.rate(for: selectedCurrency) else { return "" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 4
        
        let formattedRate = formatter.string(from: rate as NSDecimalNumber) ?? "\(rate)"
        return "1 \(rates.base) = \(formattedRate) \(selectedCurrency)"
    }
    
    var lastUpdatedText: String {
        guard case .success(let rates) = state else { return "" }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        return "Rates as of \(formatter.string(from: rates.date))"
    }
}
