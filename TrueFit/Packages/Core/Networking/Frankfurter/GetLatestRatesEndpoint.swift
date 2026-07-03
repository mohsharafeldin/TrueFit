import Foundation

struct GetLatestRatesEndpoint: GenericEndpoint {
    let baseCurrency: String
    
    init(baseCurrency: String = "USD") {
        self.baseCurrency = baseCurrency
    }
    
    var baseURL: URL {
        return URL(string: "https://api.frankfurter.app")!
    }
    
    var path: String {
        return "/latest"
    }
    
    var queryItems: [URLQueryItem]? {
        return [URLQueryItem(name: "from", value: baseCurrency)]
    }
}
