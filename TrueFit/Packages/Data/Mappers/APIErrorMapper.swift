import Foundation

enum APIErrorMapper {
    static func map(_ error: APIError) -> AppError {
        switch error {
        case .invalidURL:
            return .invalidRequest
        case .missingToken:
            return .invalidRequest
        case .unauthorized:
            return .unauthorized
        case .forbidden:
            return .forbidden
        case .notFound:
            return .notFound
        case .rateLimited:
            return .rateLimited
        case .serverError(let code):
            return .serverError(code)
        case .decodingFailed:
            return .decodingFailed
        case .graphQLErrors(let messages):
            return .unknown(messages.joined(separator: ", "))
        case .noInternetConnection:
            return .noInternet
        case .noData:
            return .unknown("No data returned from API")
        case .unknown(let error):
            return .unknown(error.localizedDescription)
        }
    }
}
