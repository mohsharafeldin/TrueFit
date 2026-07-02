import Foundation

enum GenericAPIError: Error, LocalizedError {
    case invalidURL
    case noInternet
    case serverError(Int)
    case decodingFailed(Error)
    case rateLimited
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The requested URL is invalid."
        case .noInternet:
            return "Please check your internet connection and try again."
        case .serverError(let code):
            return "Server error occurred with status code: \(code)."
        case .decodingFailed(let error):
            return "Failed to parse the response: \(error.localizedDescription)"
        case .rateLimited:
            return "You are making too many requests. Please try again later."
        case .unknown(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}
