import Foundation

enum ErrorSeverity {
    case low        // decoding, unknown — log only
    case medium     // notFound, rateLimited — show message
    case high       // unauthorized, serverError — show message + log
    case critical   // forbidden, invalidRequest — alert + log
}

enum AppError: Error, LocalizedError, Equatable {
    // Connectivity
    case noInternet
    
    // Auth
    case unauthorized           // 401 — session expired
    case forbidden              // 403 — insufficient permissions
    
    // Resource
    case notFound               // 404
    case conflict               // 409
    
    // Server
    case serverError(Int)       // 5xx with code
    case rateLimited            // 429 — after retries exhausted
    
    // Client
    case invalidRequest         // bad URL, bad body encoding
    case decodingFailed         // response parsing failed
    
    // Business
    case featureUnavailable(String)   // feature flag off, region locked etc.
    
    // Fallback
    case unknown(String)        // message from the original error
    
    var userMessage: String {
        switch self {
        case .noInternet:
            return "Please check your internet connection and try again."
        case .unauthorized:
            return "Your session has expired. Please log in again."
        case .forbidden:
            return "You don't have permission to perform this action."
        case .notFound:
            return "The requested resource could not be found."
        case .conflict:
            return "There was a conflict with your request. Please try again."
        case .serverError(_):
            return "Our servers are currently experiencing issues. Please try again later."
        case .rateLimited:
            return "You are making too many requests. Please try again later."
        case .invalidRequest:
            return "There was a problem with your request. Please try again."
        case .decodingFailed:
            return "We encountered an issue processing the data. Please try again."
        case .featureUnavailable(let message):
            return message
        case .unknown(_):
            return "An unexpected error occurred. Please try again later."
        }
    }
    
    var isRetryable: Bool {
        switch self {
        case .noInternet, .serverError, .rateLimited, .unknown:
            return true
        case .unauthorized, .forbidden, .notFound, .conflict, .invalidRequest, .decodingFailed, .featureUnavailable:
            return false
        }
    }
    
    var severity: ErrorSeverity {
        switch self {
        case .decodingFailed, .unknown:
            return .low
        case .notFound, .rateLimited, .featureUnavailable, .noInternet:
            return .medium
        case .unauthorized, .serverError:
            return .high
        case .forbidden, .invalidRequest, .conflict:
            return .critical
        }
    }
}
